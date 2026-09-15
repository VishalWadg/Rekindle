import type { Interest, Snippet } from '../types';

export const INITIAL_INTERESTS: Interest[] = [
  {
    id: 'int-1',
    name: 'distributed systems',
    alpha: 4,
    beta: 1,
    snippetCount: 3,
    createdAt: '2026-06-12T10:00:00Z',
  },
  {
    id: 'int-2',
    name: 'stoic philosophy',
    alpha: 3,
    beta: 2,
    snippetCount: 2,
    createdAt: '2026-05-10T14:30:00Z',
  },
  {
    id: 'int-3',
    name: 'urban architecture',
    alpha: 2,
    beta: 1,
    snippetCount: 1,
    createdAt: '2026-08-01T09:15:00Z',
  },
  {
    id: 'int-4',
    name: 'japanese woodworking',
    alpha: 1,
    beta: 1,
    snippetCount: 0,
    createdAt: '2026-09-01T16:45:00Z',
  },
];

export const INITIAL_SNIPPETS: Snippet[] = [
  {
    id: 'snip-1',
    interestId: 'int-1',
    interestName: 'distributed systems',
    content: 'The best mental model for eventual consistency is a letter sent across the ocean: you know it was penned, but you cannot be certain when it arrives, or whether two letters will be opened in the order they were written.',
    savedAt: 'saved 3 months ago',
    createdAt: '2026-06-14T11:20:00Z',
  },
  {
    id: 'snip-2',
    interestId: 'int-2',
    interestName: 'stoic philosophy',
    content: 'Waste no more time arguing about what a good person should be. Be one.',
    savedAt: 'saved 1 year ago',
    createdAt: '2025-09-10T08:00:00Z',
  },
  {
    id: 'snip-3',
    interestId: 'int-3',
    interestName: 'urban architecture',
    content: 'Why Roman marine concrete strengthened over millennia: self-healing lime clasts interact with seawater to precipitate calcite into micro-cracks before they can propagate.',
    savedAt: 'saved 1 month ago',
    createdAt: '2026-08-05T12:00:00Z',
  },
  {
    id: 'snip-4',
    interestId: 'int-1',
    interestName: 'distributed systems',
    content: 'A distributed system is one in which the failure of a computer you didn\'t even know existed can render your own computer unusable.',
    savedAt: 'saved 5 months ago',
    createdAt: '2026-04-18T15:30:00Z',
  },
  {
    id: 'snip-5',
    interestId: 'int-2',
    interestName: 'stoic philosophy',
    content: 'We suffer more often in imagination than in reality.',
    savedAt: 'saved 6 months ago',
    createdAt: '2026-03-22T19:10:00Z',
  },
  {
    id: 'snip-6',
    interestId: 'int-1',
    interestName: 'distributed systems',
    content: 'Network partitions are not an exception to be handled; they are the baseline environment upon which all distributed consensus must be quietly negotiated.',
    savedAt: 'saved 2 weeks ago',
    createdAt: '2026-08-28T17:45:00Z',
  },
];