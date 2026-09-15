import React from 'react';
import { PillTag } from '../../components/PillTag';
import { ActionButton } from '../../components/ActionButton';

export const PlaygroundScreen: React.FC = () => {
  return (
    <main className="flex-1 max-w-xl w-full mx-auto px-4 sm:px-6 py-6 sm:py-8 space-y-8 sm:space-y-10">
      <div>
        <h1 className="text-[17px] font-medium text-[var(--foreground)] tracking-tight lowercase">
          design playground
        </h1>
        <p className="text-xs text-[var(--muted-foreground)] mt-1">
          visual verification for tokens, typography, and atomic primitives.
        </p>
      </div>

      {/* Color Palette Swatches */}
      <section className="space-y-3">
        <h2 className="text-xs uppercase tracking-wider text-[var(--muted-foreground)] font-medium">
          color palette
        </h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 sm:gap-3">
          <div className="p-3 rounded-xl border border-[var(--border)] bg-[var(--background)]">
            <span className="block text-xs font-medium text-[var(--foreground)]">page bg</span>
            <span className="text-[10px] sm:text-[11px] text-[var(--muted-foreground)] font-mono">--background</span>
          </div>
          <div className="p-3 rounded-xl border border-[var(--border)] bg-[var(--card)]">
            <span className="block text-xs font-medium text-[var(--foreground)]">surface card</span>
            <span className="text-[10px] sm:text-[11px] text-[var(--muted-foreground)] font-mono">--card</span>
          </div>
          <div className="p-3 rounded-xl border border-[var(--border)] bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)]">
            <span className="block text-xs font-medium">accent tint</span>
            <span className="text-[10px] sm:text-[11px] opacity-80 font-mono">#F7E6D3</span>
          </div>
          <div className="p-3 rounded-xl border border-[var(--border)] bg-[var(--accent)] text-white">
            <span className="block text-xs font-medium">ember accent</span>
            <span className="text-[10px] sm:text-[11px] opacity-80 font-mono">#C6742F</span>
          </div>
        </div>
      </section>

      {/* Typography Contrast */}
      <section className="space-y-3">
        <h2 className="text-xs uppercase tracking-wider text-[var(--muted-foreground)] font-medium">
          typography dual-role
        </h2>
        <div className="p-4 sm:p-5 rounded-2xl border border-[var(--border)] bg-[var(--card)] space-y-4">
          <div>
            <span className="text-[11px] text-[var(--muted-foreground)] uppercase tracking-wide block mb-1">
              sans-serif ui chrome (manrope / figtree, regular 400 & medium 500 only)
            </span>
            <p className="text-sm text-[var(--foreground)] font-normal">
              Used strictly for navigation, labels, headers, and metadata counters. Never bold.
            </p>
          </div>

          <div className="pt-3 border-t border-[var(--border)]">
            <span className="text-[11px] text-[var(--muted-foreground)] uppercase tracking-wide block mb-1">
              editorial serif memory font (lora, warm & found-object feel)
            </span>
            <p className="font-serif text-[17px] sm:text-[19px] text-[var(--foreground)] leading-relaxed">
              "The impediment to action advances action. What stands in the way becomes the way."
            </p>
          </div>
        </div>
      </section>

      {/* Action Buttons */}
      <section className="space-y-3">
        <h2 className="text-xs uppercase tracking-wider text-[var(--muted-foreground)] font-medium">
          action buttons & pills
        </h2>
        <div className="p-4 sm:p-5 rounded-2xl border border-[var(--border)] bg-[var(--card)] space-y-4 sm:space-y-5">
          <div className="flex flex-wrap items-center gap-2.5 sm:gap-3">
            <ActionButton variant="keep" onClick={() => {}} />
            <ActionButton variant="skip" onClick={() => {}} />
            <ActionButton variant="explore" onClick={() => {}} />
          </div>

          <div className="flex flex-wrap items-center gap-2 pt-2 border-t border-[var(--border)]">
            <PillTag label="distributed systems" />
            <PillTag label="stoic philosophy" />
            <PillTag label="woodworking" />
          </div>
        </div>
      </section>
    </main>
  );
};