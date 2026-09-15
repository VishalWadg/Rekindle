import { useState, useEffect } from 'react';
import type { ActiveView, Interest, Snippet } from './types';
import { INITIAL_INTERESTS, INITIAL_SNIPPETS } from './data/mockData';
import { AppHeader } from './components/AppHeader';
import { SurfaceScreen } from './features/surface/SurfaceScreen';
import { EmptyStateScreen } from './features/surface/EmptyStateScreen';
import { ManageInterestsScreen } from './features/interests/ManageInterestsScreen';
import { ExploreMoreScreen } from './features/explore/ExploreMoreScreen';
import { PlaygroundScreen } from './features/playground/PlaygroundScreen';
import { AddSnippetModal } from './features/interests/AddSnippetModal';

export function App() {
  const [interests, setInterests] = useState<Interest[]>(INITIAL_INTERESTS);
  const [snippets, setSnippets] = useState<Snippet[]>(INITIAL_SNIPPETS);
  const [currentSnippetIndex, setCurrentSnippetIndex] = useState(0);

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

  // Current active snippet
  const currentSnippet = snippets.length > 0 ? snippets[currentSnippetIndex % snippets.length] : null;

  const advanceToNextSnippet = () => {
    if (snippets.length <= 1) return;
    setCurrentSnippetIndex((prev) => (prev + 1) % snippets.length);
  };

  const handleKeep = (snippetId: string) => {
    const snip = snippets.find((s) => s.id === snippetId);
    if (snip) {
      setInterests((prev) =>
        prev.map((i) => (i.id === snip.interestId ? { ...i, alpha: i.alpha + 1 } : i))
      );
    }
    advanceToNextSnippet();
  };

  const handleSkip = (snippetId: string) => {
    const snip = snippets.find((s) => s.id === snippetId);
    if (snip) {
      setInterests((prev) =>
        prev.map((i) => (i.id === snip.interestId ? { ...i, beta: i.beta + 1 } : i))
      );
    }
    advanceToNextSnippet();
  };

  const handleExploreMore = (interestId: string) => {
    const target = interests.find((i) => i.id === interestId);
    if (target) {
      setSelectedInterestForExplore(target);
      setActiveView('explore');
    }
  };

  // Interest management
  const handleAddInterest = (name: string) => {
    const newInterest: Interest = {
      id: `int-${Date.now()}`,
      name: name.toLowerCase(),
      alpha: 1,
      beta: 1,
      snippetCount: 0,
      createdAt: new Date().toISOString(),
    };
    setInterests((prev) => [...prev, newInterest]);
  };

  const handleDeleteInterest = (interestId: string) => {
    setInterests((prev) => prev.filter((i) => i.id !== interestId));
    setSnippets((prev) => prev.filter((s) => s.interestId !== interestId));
    if (selectedInterestForExplore?.id === interestId) {
      setSelectedInterestForExplore(null);
      setActiveView('surface');
    }
  };

  // Snippet management
  const handleSaveSnippet = (interestId: string, content: string) => {
    const targetInterest = interests.find((i) => i.id === interestId);
    if (!targetInterest) return;

    const newSnippet: Snippet = {
      id: `snip-${Date.now()}`,
      interestId,
      interestName: targetInterest.name,
      content,
      savedAt: 'saved just now',
      createdAt: new Date().toISOString(),
    };

    setSnippets((prev) => [newSnippet, ...prev]);
    setInterests((prev) =>
      prev.map((i) => (i.id === interestId ? { ...i, snippetCount: i.snippetCount + 1 } : i))
    );
  };

  const handleEditSnippet = (snippetId: string, newContent: string) => {
    setSnippets((prev) =>
      prev.map((s) => (s.id === snippetId ? { ...s, content: newContent } : s))
    );
  };

  const handleDeleteSnippet = (snippetId: string) => {
    const snip = snippets.find((s) => s.id === snippetId);
    if (!snip) return;
    setSnippets((prev) => prev.filter((s) => s.id !== snippetId));
    setInterests((prev) =>
      prev.map((i) =>
        i.id === snip.interestId ? { ...i, snippetCount: Math.max(0, i.snippetCount - 1) } : i
      )
    );
  };

  const snippetsForExplore = selectedInterestForExplore
    ? snippets.filter((s) => s.interestId === selectedInterestForExplore.id)
    : [];

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
          onAddInterest={handleAddInterest}
          onDeleteInterest={handleDeleteInterest}
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
          snippets={snippetsForExplore}
          onBack={() => setActiveView('surface')}
          onOpenAddSnippet={(interest) => setModalTargetInterest(interest)}
          onEditSnippet={handleEditSnippet}
          onDeleteSnippet={handleDeleteSnippet}
        />
      )}

      {/* Playground View */}
      {activeView === 'playground' && <PlaygroundScreen />}

      {/* Add Snippet Modal */}
      <AddSnippetModal
        interest={modalTargetInterest}
        onClose={() => setModalTargetInterest(null)}
        onSave={handleSaveSnippet}
      />
    </div>
  );
}

export default App;