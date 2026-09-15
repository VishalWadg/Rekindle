import React from 'react';

interface PillTagProps {
  label: string;
  onClick?: () => void;
  className?: string;
}

export const PillTag: React.FC<PillTagProps> = ({ label, onClick, className = '' }) => {
  const baseClasses = "inline-flex items-center px-3 py-1 rounded-full text-xs font-medium tracking-wide bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] transition-opacity";
  const interactiveClasses = onClick ? "cursor-pointer hover:opacity-85" : "";

  return (
    <span onClick={onClick} className={`${baseClasses} ${interactiveClasses} ${className}`}>
      {label.toLowerCase()}
    </span>
  );
};