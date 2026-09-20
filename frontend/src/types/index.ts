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
  exposureId?: string;
  interestId: string;
  interestName: string;
  content: string;
  savedAt?: string;
  createdAt: string;
}

export type ActiveView = 'surface' | 'interests' | 'explore';