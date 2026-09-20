import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import type { ActiveView, Interest, Snippet } from './types';
import { api } from './api/client';
import { AppHeader } from './components/AppHeader';
import { SurfaceScreen } from './features/surface/SurfaceScreen';
import { EmptyStateScreen } from './features/surface/EmptyStateScreen';
import { ManageInterestsScreen } from './features/interests/ManageInterestsScreen';
import { ExploreMoreScreen } from './features/explore/ExploreMoreScreen';
import { AddSnippetModal } from './features/interests/AddSnippetModal';

export function App() {
  const queryClient = useQueryClient();

  const [activeView, setActiveView] = useState<ActiveView>('surface');
  const [selectedInterestForExplore, setSelectedInterestForExplore] = useState<Interest | null>(null);
  const [modalTargetInterest, setModalTargetInterest] = useState<Interest | null>(null);

  // Dark Mode
  const [isDark, setIsDark] = useState<boolean>(() => {
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  });

  useEffect(() => {
    if (isDark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDark]);

  const toggleTheme = () => setIsDark((prev) => !prev);

  // 1. Query all interests from Spring Boot
  const { data: interests = [] } = useQuery<Interest[]>({
    queryKey: ['interests'],
    queryFn: async () => {
      const { data, error } = await api.GET('/api/interests');
      if (error) throw error;
      return (data || []).map((i) => ({
        id: i.id || '',
        name: i.name || '',
        alpha: i.alpha ?? 1,
        beta: i.beta ?? 1,
        snippetCount: Number(i.snippetCount || 0),
        createdAt: i.createdAt || '',
      }));
    },
  });

  // 2. Query surfaced thought from Thompson Sampling engine
  const { data: currentSnippet = null } = useQuery<Snippet | null>({
    queryKey: ['surface'],
    queryFn: async () => {
      const { data, response } = await api.GET('/api/surface');
      if (response.status === 204 || !data || !data.snippetId) return null;
      const snippet: Snippet = {
        id: data.snippetId,
        exposureId: data.exposureId,
        interestId: data.interestId || '',
        interestName: data.interestName || '',
        content: data.content || '',
        createdAt: data.createdAt || '',
      };
      return snippet;
    },
  });

  // 3. Query snippets when exploring a specific interest
  const { data: exploreSnippets = [] } = useQuery<Snippet[]>({
    queryKey: ['snippets', selectedInterestForExplore?.id],
    enabled: !!selectedInterestForExplore,
    queryFn: async () => {
      if (!selectedInterestForExplore) return [];
      const { data, error } = await api.GET('/api/interests/{interestId}/snippets', {
        params: { path: { interestId: selectedInterestForExplore.id } },
      });
      if (error) throw error;
      return (data || []).map((s) => ({
        id: s.id || '',
        interestId: s.interestId || '',
        interestName: s.interestName || '',
        content: s.content || '',
        createdAt: s.createdAt || '',
      }));
    },
  });

  // 4. Feedback mutation (Keep / Skip / Explore)
  const feedbackMutation = useMutation({
    mutationFn: async ({ exposureId, reaction }: { exposureId: string; reaction: 'keep' | 'skip' | 'explore' }) => {
      await api.POST('/api/exposures/{id}/feedback', {
        params: { path: { id: exposureId } },
        body: { reaction },
      });
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['surface'] });
      queryClient.invalidateQueries({ queryKey: ['interests'] });
    },
  });

  const handleKeep = (idOrExposureId: string) => {
    const exposureId = currentSnippet?.exposureId || idOrExposureId;
    if (exposureId) {
      feedbackMutation.mutate({ exposureId, reaction: 'keep' });
    }
  };

  const handleSkip = (idOrExposureId: string) => {
    const exposureId = currentSnippet?.exposureId || idOrExposureId;
    if (exposureId) {
      feedbackMutation.mutate({ exposureId, reaction: 'skip' });
    }
  };

  const handleExploreMore = (interestId: string, exposureId?: string) => {
    const targetExposureId = exposureId || currentSnippet?.exposureId;
    if (targetExposureId) {
      feedbackMutation.mutate({ exposureId: targetExposureId, reaction: 'explore' });
    }
    const target = interests.find((i) => i.id === interestId);
    if (target) {
      setSelectedInterestForExplore(target);
      setActiveView('explore');
    }
  };

  // 5. Interest mutations
  const createInterestMutation = useMutation({
    mutationFn: async (name: string) => {
      const { data, error } = await api.POST('/api/interests', {
        body: { name },
      });
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['interests'] });
      queryClient.invalidateQueries({ queryKey: ['surface'] });
    },
  });

  const deleteInterestMutation = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await api.DELETE('/api/interests/{id}', {
        params: { path: { id } },
      });
      if (error) throw error;
    },
    onSuccess: (_, deletedId) => {
      queryClient.invalidateQueries({ queryKey: ['interests'] });
      queryClient.invalidateQueries({ queryKey: ['surface'] });
      if (selectedInterestForExplore?.id === deletedId) {
        setSelectedInterestForExplore(null);
        setActiveView('surface');
      }
    },
  });

  // 6. Snippet mutations
  const createSnippetMutation = useMutation({
    mutationFn: async ({ interestId, content }: { interestId: string; content: string }) => {
      const { data, error } = await api.POST('/api/interests/{interestId}/snippets', {
        params: { path: { interestId } },
        body: { content },
      });
      if (error) throw error;
      return data;
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['snippets', variables.interestId] });
      queryClient.invalidateQueries({ queryKey: ['interests'] });
      queryClient.invalidateQueries({ queryKey: ['surface'] });
    },
  });

  const updateSnippetMutation = useMutation({
    mutationFn: async ({ snippetId, content }: { snippetId: string; content: string }) => {
      const { data, error } = await api.PUT('/api/snippets/{id}', {
        params: { path: { id: snippetId } },
        body: { content },
      });
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      if (selectedInterestForExplore) {
        queryClient.invalidateQueries({ queryKey: ['snippets', selectedInterestForExplore.id] });
      }
      queryClient.invalidateQueries({ queryKey: ['surface'] });
    },
  });

  const deleteSnippetMutation = useMutation({
    mutationFn: async (snippetId: string) => {
      const { error } = await api.DELETE('/api/snippets/{id}', {
        params: { path: { id: snippetId } },
      });
      if (error) throw error;
    },
    onSuccess: () => {
      if (selectedInterestForExplore) {
        queryClient.invalidateQueries({ queryKey: ['snippets', selectedInterestForExplore.id] });
      }
      queryClient.invalidateQueries({ queryKey: ['interests'] });
      queryClient.invalidateQueries({ queryKey: ['surface'] });
    },
  });

  return (
    <div className="min-h-screen flex flex-col bg-[var(--background)] text-[var(--foreground)] transition-colors duration-200">
      {/* Chrome Header */}
      <AppHeader
        activeView={activeView}
        onNavigate={(view) => setActiveView(view)}
        isDark={isDark}
        onToggleTheme={toggleTheme}
      />

      {/* Surface / Home View: Shows dedicated EmptyState if 0 interests, else SurfaceScreen */}
      {activeView === 'surface' && (
        interests.length === 0 ? (
          <EmptyStateScreen onAddFirstInterest={() => setActiveView('interests')} />
        ) : (
          <SurfaceScreen
            snippet={currentSnippet}
            onKeep={handleKeep}
            onSkip={handleSkip}
            onExploreMore={handleExploreMore}
            onAddFirstInterest={() => setActiveView('interests')}
          />
        )
      )}

      {/* Interests Management View */}
      {activeView === 'interests' && (
        <ManageInterestsScreen
          interests={interests}
          onAddInterest={(name) => createInterestMutation.mutate(name)}
          onDeleteInterest={(id) => deleteInterestMutation.mutate(id)}
          onSelectInterest={(interest) => {
            setSelectedInterestForExplore(interest);
            setActiveView('explore');
          }}
          onOpenAddSnippet={(interest) => setModalTargetInterest(interest)}
          onBackToSurface={() => setActiveView('surface')}
        />
      )}

      {/* Explore More View */}
      {activeView === 'explore' && selectedInterestForExplore && (
        <ExploreMoreScreen
          interest={selectedInterestForExplore}
          snippets={exploreSnippets}
          onBack={() => setActiveView('surface')}
          onOpenAddSnippet={(interest) => setModalTargetInterest(interest)}
          onEditSnippet={(snippetId, content) => updateSnippetMutation.mutate({ snippetId, content })}
          onDeleteSnippet={(snippetId) => deleteSnippetMutation.mutate(snippetId)}
        />
      )}

      {/* Add Snippet Modal */}
      <AddSnippetModal
        interest={modalTargetInterest}
        onClose={() => setModalTargetInterest(null)}
        onSave={(interestId, content) => createSnippetMutation.mutate({ interestId, content })}
      />
    </div>
  );
}

export default App;