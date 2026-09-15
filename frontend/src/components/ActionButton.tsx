import React from 'react';

interface ActionButtonProps {
  variant: 'keep' | 'skip' | 'explore';
  onClick: () => void;
  disabled?: boolean;
  children?: React.ReactNode;
  className?: string;
}

export const ActionButton: React.FC<ActionButtonProps> = ({
  variant,
  onClick,
  disabled = false,
  children,
  className = '',
}) => {
  if (variant === 'keep') {
    return (
      <button
        type="button"
        disabled={disabled}
        onClick={onClick}
        className={`px-7 py-3 min-h-[46px] rounded-lg text-sm font-medium bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] hover:opacity-90 active:scale-[0.98] transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed select-none inline-flex items-center justify-center ${className}`}
      >
        {children || 'keep'}
      </button>
    );
  }

  if (variant === 'skip') {
    return (
      <button
        type="button"
        disabled={disabled}
        onClick={onClick}
        className={`px-7 py-3 min-h-[46px] rounded-lg text-sm font-medium bg-transparent text-[var(--muted-foreground)] border border-[var(--border)] hover:text-[var(--foreground)] hover:border-[var(--muted-foreground)] active:scale-[0.98] transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed select-none inline-flex items-center justify-center ${className}`}
      >
        {children || 'skip'}
      </button>
    );
  }

  return (
    <button
      type="button"
      disabled={disabled}
      onClick={onClick}
      className={`text-xs text-[var(--muted-foreground)] hover:text-[var(--foreground)] active:scale-[0.98] transition-colors py-2 px-3 cursor-pointer disabled:opacity-50 inline-flex items-center gap-1.5 select-none ${className}`}
    >
      {children || (
        <>
          explore more <span aria-hidden="true">→</span>
        </>
      )}
    </button>
  );
};