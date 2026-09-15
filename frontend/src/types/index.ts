export type ReactionType = 'skip' | 'keep' | 'explore' | 'none';

export interface Interest {
  id: string;
  name: string;
  alpha: number;
  beta: number;
  snippetCount: number;
  createdAt: string;
}

export interface Snippet {
  id: string;
  interestId: string;
  interestName: string;
  content: string;
  savedAt: string; // human-readable, e.g. "3 months ago"
  createdAt: string;
}

export type ActiveView = 'surface' | 'interests' | 'explore' | 'playground';