import React, { useState } from 'react';
import rekindleLogo from '../assets/RekindleLogo.png';
import type { ActiveView } from '../types';
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
} from './ui/dropdown-menu';

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
          <span className="font-brand text-[clamp(1.125rem,2.5vw,1.35rem)] font-medium tracking-tight text-[var(--foreground)]">
            Rekindle
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

        {/* Mobile Navigation with shadcn DropdownMenu (sm:hidden) */}
        <div className="flex sm:hidden items-center gap-1">
          <button
            type="button"
            onClick={onToggleTheme}
            title={isDark ? 'Switch to warm light mode' : 'Switch to dark mode'}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[14px] text-[var(--muted-foreground)] hover:text-[var(--foreground)] transition-colors cursor-pointer"
          >
            {isDark ? '☼' : '☽'}
          </button>

          <DropdownMenu open={isMobileMenuOpen} onOpenChange={setIsMobileMenuOpen}>
            <DropdownMenuTrigger asChild>
              <button
                type="button"
                aria-label={isMobileMenuOpen ? 'Close menu' : 'Open menu'}
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
            </DropdownMenuTrigger>

            <DropdownMenuContent
              align="end"
              sideOffset={8}
              className="sm:hidden w-48 bg-[var(--card)] border border-[var(--border)] rounded-2xl p-2 shadow-[0_4px_20px_rgba(0,0,0,0.06)] space-y-1 z-50"
            >
              <DropdownMenuItem
                onClick={() => handleNavClick('surface')}
                className={`w-full px-4 py-3 rounded-xl text-[15px] transition-colors cursor-pointer flex items-center justify-between ${
                  activeView === 'surface'
                    ? 'bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] font-medium'
                    : 'text-[var(--foreground)] hover:bg-[var(--border)]/40 font-normal'
                }`}
              >
                <span>surface</span>
                {activeView === 'surface' && <span className="text-xs">●</span>}
              </DropdownMenuItem>

              <DropdownMenuItem
                onClick={() => handleNavClick('interests')}
                className={`w-full px-4 py-3 rounded-xl text-[15px] transition-colors cursor-pointer flex items-center justify-between ${
                  activeView === 'interests'
                    ? 'bg-[var(--accent-tint-bg)] text-[var(--accent-tint-fg)] font-medium'
                    : 'text-[var(--foreground)] hover:bg-[var(--border)]/40 font-normal'
                }`}
              >
                <span>interests</span>
                {activeView === 'interests' && <span className="text-xs">●</span>}
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  );
};