import React from 'react';
import rekindleLogo from '../../assets/RekindleLogo.png';

interface EmptyStateScreenProps {
  onAddFirstInterest: () => void;
}

export const EmptyStateScreen: React.FC<EmptyStateScreenProps> = ({ onAddFirstInterest }) => {
  return (
    <main className="flex-1 flex flex-col items-center justify-center px-4 sm:px-6 py-12 sm:py-20 text-center">
      <div className="max-w-sm w-full space-y-6 sm:space-y-7 flex flex-col items-center">
        <img
          src={rekindleLogo}
          alt="Rekindle flame logo"
          className="w-12 h-12 sm:w-14 sm:h-14 object-contain opacity-90"
        />
        <div className="space-y-2 sm:space-y-2.5">
          <h1 className="font-serif text-[20px] sm:text-[22px] text-[var(--foreground)] tracking-tight">
            rekindle thoughts you loved
          </h1>
          <p className="text-sm text-[var(--muted-foreground)] leading-relaxed font-normal">
            a quiet place to save things you found fascinating, and rediscover them when you are idle.
          </p>
        </div>

        <button
          type="button"
          onClick={onAddFirstInterest}
          className="w-full sm:w-auto px-7 py-3 rounded-lg text-sm font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer"
        >
          add your first interest
        </button>
      </div>
    </main>
  );
};