import React, { useState } from 'react';
import type { Interest } from '../../types';

interface ManageInterestsScreenProps {
  interests: Interest[];
  onAddInterest: (name: string) => void;
  onDeleteInterest?: (interestId: string) => void;
  onSelectInterest: (interest: Interest) => void;
  onOpenAddSnippet: (interest: Interest) => void;
  onBackToSurface: () => void;
}

export const ManageInterestsScreen: React.FC<ManageInterestsScreenProps> = ({
  interests,
  onAddInterest,
  onDeleteInterest,
  onSelectInterest,
  onOpenAddSnippet,
  onBackToSurface,
}) => {
  const [isAdding, setIsAdding] = useState(false);
  const [newInterestName, setNewInterestName] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newInterestName.trim()) return;
    onAddInterest(newInterestName.trim());
    setNewInterestName('');
    setIsAdding(false);
  };

  return (
    <main className="flex-1 max-w-xl w-full mx-auto px-4 sm:px-6 py-6 sm:py-8">
      {/* Header */}
      <div className="flex items-center justify-between pb-5 sm:pb-6 mb-2 border-b border-[var(--border)]">
        <div>
          <button
            type="button"
            onClick={onBackToSurface}
            className="text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] transition-colors mb-1.5 inline-flex items-center gap-1 cursor-pointer"
          >
            ← back to surface
          </button>
          <h1 className="text-[17px] font-medium text-[var(--foreground)] tracking-tight lowercase">
            your interests
          </h1>
        </div>

        {!isAdding && (
          <button
            type="button"
            onClick={() => setIsAdding(true)}
            className="text-xs font-medium px-3.5 py-2 rounded-lg bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer inline-flex items-center gap-1"
          >
            <span>+</span> add interest
          </button>
        )}
      </div>

      {/* Minimal Add Interest Form */}
      {isAdding && (
        <form onSubmit={handleSubmit} className="mb-6 p-4 rounded-xl border border-[var(--border)] bg-[var(--card)] space-y-3">
          <label htmlFor="interest-name" className="block text-xs font-medium text-[var(--muted-foreground)] lowercase">
            name your interest
          </label>
          <input
            id="interest-name"
            type="text"
            autoFocus
            placeholder="e.g. quantum computing, woodworking, poetry"
            value={newInterestName}
            onChange={(e) => setNewInterestName(e.target.value)}
            className="w-full px-3.5 py-2.5 text-sm rounded-lg bg-transparent border border-[var(--border)] text-[var(--foreground)] placeholder:text-[var(--muted-foreground)]/60 focus:outline-none focus:border-[var(--accent)] transition-colors"
          />
          <div className="flex items-center gap-2 justify-end pt-1">
            <button
              type="button"
              onClick={() => {
                setIsAdding(false);
                setNewInterestName('');
              }}
              className="px-3.5 py-2 text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] cursor-pointer"
            >
              cancel
            </button>
            <button
              type="submit"
              disabled={!newInterestName.trim()}
              className="px-4.5 py-2 rounded-lg text-xs font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
            >
              add
            </button>
          </div>
        </form>
      )}

      {/* Interests List */}
      {interests.length === 0 ? (
        <div className="py-16 text-center text-sm text-[var(--muted-foreground)] space-y-3">
          <p>no interests yet. click "+ add interest" above to start your collection.</p>
        </div>
      ) : (
        <ul className="divide-y divide-[var(--border)]">
          {interests.map((interest) => (
            <li
              key={interest.id}
              className="py-3.5 sm:py-4 flex items-center justify-between group transition-colors gap-2"
            >
              <button
                type="button"
                onClick={() => onSelectInterest(interest)}
                className="text-left flex-1 text-[15px] font-normal text-[var(--foreground)] lowercase hover:text-[var(--accent)] transition-colors cursor-pointer truncate"
              >
                {interest.name}
              </button>

              <div className="flex items-center gap-2 sm:gap-3 shrink-0">
                {interest.snippetCount > 0 ? (
                  <button
                    type="button"
                    onClick={() => onSelectInterest(interest)}
                    className="text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] cursor-pointer"
                  >
                    {interest.snippetCount} {interest.snippetCount === 1 ? 'thought' : 'thoughts'}
                  </button>
                ) : (
                  <button
                    type="button"
                    onClick={() => onOpenAddSnippet(interest)}
                    className="text-xs font-medium text-[var(--accent-tint-text)] hover:opacity-80 cursor-pointer"
                  >
                    add a snippet →
                  </button>
                )}

                <button
                  type="button"
                  title="Add thought under this topic"
                  onClick={() => onOpenAddSnippet(interest)}
                  className="w-7 h-7 rounded-full flex items-center justify-center text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] hover:bg-[var(--border)]/40 transition-colors cursor-pointer"
                >
                  +
                </button>

                {onDeleteInterest && (
                  <button
                    type="button"
                    title="Remove interest"
                    onClick={() => onDeleteInterest(interest.id)}
                    className="w-7 h-7 rounded-full flex items-center justify-center text-xs text-[var(--muted-foreground)]/50 hover:text-[var(--destructive)] transition-colors cursor-pointer sm:opacity-0 sm:group-hover:opacity-100"
                  >
                    ✕
                  </button>
                )}
              </div>
            </li>
          ))}
        </ul>
      )}
    </main>
  );
};