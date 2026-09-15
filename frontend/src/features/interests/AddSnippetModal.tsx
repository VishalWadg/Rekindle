import React, { useState } from 'react';
import type { Interest } from '../../types';
import { PillTag } from '../../components/PillTag';

interface AddSnippetModalProps {
  interest: Interest | null;
  onClose: () => void;
  onSave: (interestId: string, content: string) => void;
}

export const AddSnippetModal: React.FC<AddSnippetModalProps> = ({
  interest,
  onClose,
  onSave,
}) => {
  const [content, setContent] = useState('');

  if (!interest) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!content.trim()) return;
    onSave(interest.id, content.trim());
    setContent('');
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/40 backdrop-blur-[2px] flex items-end sm:items-center justify-center p-0 sm:p-4">
      <div
        className="w-full max-w-lg bg-[var(--card)] border border-[var(--border)] rounded-t-[24px] sm:rounded-[20px] p-6 sm:p-7 shadow-lg space-y-5 animate-in fade-in slide-in-from-bottom-4 sm:zoom-in-95 duration-200"
      >
        <div className="flex items-center justify-between">
          <div className="space-y-1">
            <span className="text-[11px] text-[var(--muted-foreground)] tracking-wide uppercase">
              new thought under
            </span>
            <div>
              <PillTag label={interest.name} />
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="w-8 h-8 rounded-full flex items-center justify-center text-sm text-[var(--muted-foreground)] hover:text-[var(--foreground)] transition-colors cursor-pointer"
          >
            ✕
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <textarea
            autoFocus
            rows={5}
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="paste a quote, an insight, a question you want to remember..."
            className="w-full p-4 rounded-xl border border-[var(--border)] bg-transparent font-serif text-[16px] text-[var(--foreground)] placeholder:text-[var(--muted-foreground)]/50 focus:outline-none focus:border-[var(--accent)] transition-colors resize-none leading-relaxed"
          />

          <div className="flex items-center justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2.5 text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] cursor-pointer"
            >
              cancel
            </button>
            <button
              type="submit"
              disabled={!content.trim()}
              className="px-6 py-2.5 rounded-lg text-xs font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
            >
              save thought
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};