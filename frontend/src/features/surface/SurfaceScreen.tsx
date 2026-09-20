import React, { useState } from 'react';
import type { Snippet } from '../../types';
import { PillTag } from '../../components/PillTag';
import { ActionButton } from '../../components/ActionButton';

interface SurfaceScreenProps {
  snippet: Snippet | null;
  onKeep: (id: string) => void;
  onSkip: (id: string) => void;
  onExploreMore: (interestId: string, exposureId?: string) => void;
  onAddFirstInterest: () => void;
}

export const SurfaceScreen: React.FC<SurfaceScreenProps> = ({
  snippet,
  onKeep,
  onSkip,
  onExploreMore,
  onAddFirstInterest,
}) => {
  const [isTransitioning, setIsTransitioning] = useState(false);

  const handleAction = (action: 'keep' | 'skip') => {
    if (!snippet || isTransitioning) return;
    setIsTransitioning(true);
    setTimeout(() => {
      if (action === 'keep') onKeep(snippet.exposureId || snippet.id);
      else onSkip(snippet.exposureId || snippet.id);
      setIsTransitioning(false);
    }, 220);
  };

  if (!snippet) {
    return (
      <main className="flex-1 flex items-center justify-center px-4 sm:px-6 py-16">
        <div className="max-w-md w-full text-center space-y-6">
          <p className="text-base text-[var(--muted-foreground)] font-normal leading-relaxed">
            no thoughts to surface right now. add an interest or attach a new thought.
          </p>
          <div>
            <button
              type="button"
              onClick={onAddFirstInterest}
              className="px-6 py-3 rounded-lg text-sm font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer"
            >
              add an interest
            </button>
          </div>
        </div>
      </main>
    );
  }

  return (
    <main className="flex-1 flex flex-col items-center justify-center px-4 sm:px-6 py-6 sm:py-12">
      <div className="w-full max-w-lg flex flex-col items-center">
        {/* Main Found-Object Memory Card */}
        <article
          className={`w-full bg-[var(--card)] border border-[var(--border)] rounded-[20px] p-6 sm:p-10 shadow-[0_1px_3px_rgba(0,0,0,0.04)] flex flex-col items-center text-center transition-all duration-200 ${
            isTransitioning ? 'opacity-0 scale-[0.99]' : 'opacity-100 scale-100'
          }`}
        >
          {/* Topic Tag */}
          <div className="mb-6 sm:mb-7">
            <PillTag
              label={snippet.interestName}
              onClick={() => onExploreMore(snippet.interestId)}
            />
          </div>

          {/* Editorial Serif Thought Quote */}
          <blockquote className="font-serif text-[18px] sm:text-[21px] leading-[1.6] sm:leading-[1.65] text-[var(--foreground)] font-normal tracking-tight max-w-md mx-auto">
            "{snippet.content}"
          </blockquote>

          {/* Muted Metadata */}
          <div className="mt-6 sm:mt-8 pt-4 sm:pt-5 border-t border-[var(--border)]/60 w-full flex items-center justify-center">
            <span className="text-[12px] text-[var(--muted-foreground)] tracking-wide">
              {snippet.savedAt}
            </span>
          </div>
        </article>

        {/* Quiet Low-Stake Actions with mobile responsive grid */}
        <footer className="mt-7 sm:mt-9 flex flex-col items-center gap-3.5 w-full">
          <div className="grid grid-cols-2 gap-3 w-full max-w-xs sm:flex sm:w-auto sm:justify-center">
            <ActionButton
              variant="skip"
              disabled={isTransitioning}
              onClick={() => handleAction('skip')}
              className="w-full sm:w-auto"
            />
            <ActionButton
              variant="keep"
              disabled={isTransitioning}
              onClick={() => handleAction('keep')}
              className="w-full sm:w-auto"
            />
          </div>

          {/* Tertiary Action: Explore More */}
          <ActionButton
            variant="explore"
            disabled={isTransitioning}
            onClick={() => onExploreMore(snippet.interestId, snippet.exposureId)}
          />
        </footer>
      </div>
    </main>
  );
};