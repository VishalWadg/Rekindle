import React, { useState, useEffect, useRef } from 'react';
import rekindleLogo from '../assets/RekindleLogo.png';
import type { ActiveView } from '../types';

interface AppHeaderProps {
  activeView: ActiveView;
  onNavigate: (view: ActiveView) => void;
  isDark: boolean;
  onToggleTheme: () => void;
}

export const AppHeader: React.FC<AppHeaderProps> = ({
  activeView,
  onNavigate,
  isDark,
  onToggleTheme,
}) => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  // Close menu on click outside or escape key
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsMobileMenuOpen(false);
      }
    };

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        setIsMobileMenuOpen(false);
      }
    };

    if (isMobileMenuOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      document.addEventListener('keydown', handleKeyDown);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('keydown', handleKeyDown);
    };
  }, [isMobileMenuOpen]);

  const handleNavClick = (view: ActiveView) => {
    onNavigate(view);
    setIsMobileMenuOpen(false);
  };

  return (
    <header className="relative w-full max-w-xl mx-auto px-4 sm:px-6 py-4 sm:py-6 select-none z-40">
      <div className="flex items-center justify-between">
        {/* Brand logo + wordmark */}
        <button
          type="button"
          onClick={() => handleNavClick('surface')}
          className="flex items-center gap-2.5 sm:gap-3 cursor-pointer group text-left shrink-0"
        >
          <img
            src={rekindleLogo}
            alt="Rekindle flame logo"
            className="w-7 h-7 sm:w-8 sm:h-8 object-contain group-hover:scale-105 transition-transform duration-150"
          />
          <span className="text-[17px] font-medium tracking-tight text-[var(--foreground)] lowercase">
            rekindle
          </span>
        </button>

        {/* Desktop Navigation (sm and up) */}
        <nav className="hidden sm:flex items-center gap-6 text-[14px]">
          <button
            type="button"
            onClick={() => onNavigate('surface')}
            className={`transition-colors cursor-pointer ${
              activeView === 'surface'
                ? 'text-[var(--foreground)] font-medium'
                : 'text-[var(--muted-foreground)] hover:text-[var(--foreground)] font-normal'
            }`}
          >
            surface
          </button>

          <button
            type="button"
            onClick={() => onNavigate('interests')}
            className={`transition-colors cursor-pointer ${
              activeView === 'interests'
                ? 'text-[var(--foreground)] font-medium'
                : 'text-[var(--muted-foreground)] hover:text-[var(--foreground)] font-normal'
            }`}
          >
            interests
          </button>

          <button
            type="button"
            onClick={onToggleTheme}
            title={isDark ? 'Switch to warm light mode' : 'Switch to dark mode'}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[15px] text-[var(--muted-foreground)] hover:text-[var(--foreground)] hover:bg-[var(--border)]/40 transition-colors cursor-pointer ml-1"
          >
            {isDark ? '☼' : '☽'}
          </button>
        </nav>

        {/* Mobile Hamburger Button (sm:hidden) */}
        <div className="flex sm:hidden items-center gap-1">
          <button
            type="button"
            onClick={onToggleTheme}
            title={isDark ? 'Switch to warm light mode' : 'Switch to dark mode'}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[14px] text-[var(--muted-foreground)] hover:text-[var(--foreground)] transition-colors cursor-pointer"
          >
            {isDark ? '☼' : '☽'}
          </button>

          <button
            type="button"
            aria-label={isMobileMenuOpen ? 'Close menu' : 'Open menu'}
            onClick={() => setIsMobileMenuOpen((prev) => !prev)}
            className="w-9 h-9 rounded-lg flex flex-col items-center justify-center gap-1 text-[var(--foreground)] hover:bg-[var(--card)] transition-colors cursor-pointer"
          >
            <span
              className={`w-4 h-[1.5px] bg-[var(--foreground)] transition-transform duration-200 ${
                isMobileMenuOpen ? 'rotate-45 translate-y-[2.5px]' : ''
              }`}
            />
            <span
              className={`w-4 h-[1.5px] bg-[var(--foreground)] transition-transform duration-200 ${
                isMobileMenuOpen ? '-rotate-45 -translate-y-[3px]' : ''
              }`}
            />
          </button>
        </div>
      </div>

      {/* Mobile Dropdown Menu (Quiet, themed card) */}
      {isMobileMenuOpen && (
        <div
          ref={menuRef}
          className="sm:hidden absolute top-[calc(100%-8px)] left-4 right-4 bg-[var(--card)] border border-[var(--border)] rounded-2xl p-4 shadow-[0_4px_20px_rgba(0,0,0,0.06)] animate-in fade-in slide-in-from-top-2 duration-150 space-y-1"
        >
          <button
            type="button"
            onClick={() => handleNavClick('surface')}
            className={`w-full text-left px-4 py-3 rounded-xl text-[15px] transition-colors cursor-pointer flex items-center justify-between ${
              activeView === 'surface'
                ? 'bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] font-medium'
                : 'text-[var(--foreground)] hover:bg-[var(--border)]/40 font-normal'
            }`}
          >
            <span>surface</span>
            {activeView === 'surface' && <span className="text-xs">●</span>}
          </button>

          <button
            type="button"
            onClick={() => handleNavClick('interests')}
            className={`w-full text-left px-4 py-3 rounded-xl text-[15px] transition-colors cursor-pointer flex items-center justify-between ${
              activeView === 'interests'
                ? 'bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] font-medium'
                : 'text-[var(--foreground)] hover:bg-[var(--border)]/40 font-normal'
            }`}
          >
            <span>interests</span>
            {activeView === 'interests' && <span className="text-xs">●</span>}
          </button>
        </div>
      )}
    </header>
  );
};