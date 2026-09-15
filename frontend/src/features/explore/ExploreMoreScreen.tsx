import React, { useState } from 'react';
import type { Interest, Snippet } from '../../types';
import { PillTag } from '../../components/PillTag';

interface ExploreMoreScreenProps {
  interest: Interest;
  snippets: Snippet[];
  onBack: () => void;
  onOpenAddSnippet: (interest: Interest) => void;
  onDeleteSnippet?: (snippetId: string) => void;
  onEditSnippet?: (snippetId: string, newContent: string) => void;
}

export const ExploreMoreScreen: React.FC<ExploreMoreScreenProps> = ({
  interest,
  snippets,
  onBack,
  onOpenAddSnippet,
  onDeleteSnippet,
  onEditSnippet,
}) => {
  const [expandedSnippetId, setExpandedSnippetId] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editContent, setEditContent] = useState('');

  const toggleExpand = (id: string) => {
    if (editingId) return;
    setExpandedSnippetId((current) => (current === id ? null : id));
  };

  const startEdit = (e: React.MouseEvent, snip: Snippet) => {
    e.stopPropagation();
    setEditingId(snip.id);
    setEditContent(snip.content);
  };

  const saveEdit = (snippetId: string) => {
    if (!editContent.trim() || !onEditSnippet) return;
    onEditSnippet(snippetId, editContent.trim());
    setEditingId(null);
  };

  return (
    <main className="flex-1 max-w-xl w-full mx-auto px-4 sm:px-6 py-6 sm:py-8">
      {/* Navigation Header */}
      <div className="pb-5 sm:pb-6 mb-4 border-b border-[var(--border)]">
        <button
          type="button"
          onClick={onBack}
          className="text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] transition-colors mb-2.5 inline-flex items-center gap-1 cursor-pointer"
        >
          ← back to surface
        </button>
        <div className="flex items-center justify-between gap-2">
          <div className="flex items-center gap-2 sm:gap-3 flex-wrap">
            <PillTag label={interest.name} />
            <span className="text-xs text-[var(--muted-foreground)]">
              {snippets.length} {snippets.length === 1 ? 'thought' : 'thoughts'}
            </span>
          </div>

          <button
            type="button"
            onClick={() => onOpenAddSnippet(interest)}
            className="text-xs font-medium px-3.5 py-2 rounded-lg bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer shrink-0"
          >
            + add thought
          </button>
        </div>
      </div>

      {/* Snippet Feed */}
      {snippets.length === 0 ? (
        <div className="py-16 text-center space-y-4">
          <p className="text-sm text-[var(--muted-foreground)] font-normal">
            no thoughts saved under {interest.name} yet.
          </p>
          <button
            type="button"
            onClick={() => onOpenAddSnippet(interest)}
            className="px-5 py-2.5 rounded-lg text-xs font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer"
          >
            add your first thought
          </button>
        </div>
      ) : (
        <div className="space-y-3.5 sm:space-y-4">
          {snippets.map((snip) => {
            const isExpanded = expandedSnippetId === snip.id;
            const isEditing = editingId === snip.id;

            return (
              <article
                key={snip.id}
                onClick={() => toggleExpand(snip.id)}
                className={`p-5 sm:p-6 rounded-2xl border border-[var(--border)] bg-[var(--card)] transition-all cursor-pointer ${
                  isExpanded ? 'shadow-sm' : 'hover:border-[var(--muted-foreground)]/40'
                }`}
              >
                {isEditing ? (
                  <div className="space-y-3" onClick={(e) => e.stopPropagation()}>
                    <textarea
                      rows={4}
                      value={editContent}
                      onChange={(e) => setEditContent(e.target.value)}
                      className="w-full p-3 rounded-lg border border-[var(--border)] bg-transparent font-serif text-[15px] sm:text-[16px] text-[var(--foreground)] focus:outline-none focus:border-[var(--accent)] resize-none leading-relaxed"
                    />
                    <div className="flex justify-end gap-2 text-xs">
                      <button
                        type="button"
                        onClick={() => setEditingId(null)}
                        className="px-3 py-2 text-[var(--muted-foreground)] hover:text-[var(--foreground)] cursor-pointer"
                      >
                        cancel
                      </button>
                      <button
                        type="button"
                        onClick={() => saveEdit(snip.id)}
                        className="px-4 py-2 rounded-lg font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] cursor-pointer"
                      >
                        save
                      </button>
                    </div>
                  </div>
                ) : (
                  <>
                    <blockquote
                      className={`font-serif text-[16px] sm:text-[17px] text-[var(--foreground)] leading-relaxed ${
                        !isExpanded ? 'line-clamp-3' : ''
                      }`}
                    >
                      "{snip.content}"
                    </blockquote>

                    <div className="mt-3.5 sm:mt-4 flex items-center justify-between text-xs text-[var(--muted-foreground)]">
                      <span>{snip.savedAt}</span>
                      <div className="flex items-center gap-3">
                        <button
                          type="button"
                          onClick={(e) => startEdit(e, snip)}
                          className="text-[12px] p-1 text-[var(--muted-foreground)] hover:text-[var(--foreground)] cursor-pointer"
                        >
                          edit
                        </button>
                        {onDeleteSnippet && (
                          <button
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              onDeleteSnippet(snip.id);
                            }}
                            className="text-[12px] p-1 text-[var(--muted-foreground)] hover:text-[var(--destructive)] cursor-pointer"
                          >
                            delete
                          </button>
                        )}
                      </div>
                    </div>
                  </>
                )}
              </article>
            );
          })}
        </div>
      )}
    </main>
  );
};