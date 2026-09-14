CREATE TABLE interests (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alpha INT NOT NULL DEFAULT 1,
    beta INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE snippets (
    id UUID PRIMARY KEY,
    interest_id UUID NOT NULL REFERENCES interests(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE exposures (
    id UUID PRIMARY KEY,
    snippet_id UUID NOT NULL REFERENCES snippets(id) ON DELETE CASCADE,
    surfaced_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    reaction VARCHAR (50) NOT NULL DEFAULT 'none',
    responded_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX snippet_interest_idx ON snippets(interest_id);
CREATE INDEX exposure_snippet_idx ON exposures(snippet_id);