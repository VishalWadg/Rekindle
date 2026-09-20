import createClient from 'openapi-fetch';
import type { paths } from '../types/api';

export const api = createClient<paths>({
  baseUrl: 'http://localhost:8080',
});

// Convenient shortcut types extracted from generated OpenAPI paths
export type InterestResponse = paths['/api/interests']['get']['responses'][200]['content']['*/*'][number];
export type SnippetResponse = paths['/api/interests/{interestId}/snippets']['get']['responses'][200]['content']['*/*'][number];
export type SurfaceResponse = NonNullable<paths['/api/surface']['get']['responses'][200]['content']['*/*']>;
