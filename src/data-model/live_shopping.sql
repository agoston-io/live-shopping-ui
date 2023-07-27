create table agoston_public.users
(
    -- Id from agoston_identity.user_identities (id)
    id integer not null PRIMARY KEY,
    -- Custom user data that fit your application logic
    username text not null default 'unknown',
    CONSTRAINT user_details_username_key UNIQUE (username),
    -- Reference to agoston_identity.user_identities (id):
    CONSTRAINT user_details_id FOREIGN KEY (id)
        REFERENCES agoston_identity.user_identities (id)
        -- Necessary to ensure that delete user via
        -- the Agoston function agoston_api.delete_user
        -- get also removed here transparently:
        ON DELETE CASCADE
);
GRANT SELECT ON users TO anonymous, authenticated;

-- Create the trigger function on the table agoston_identity.user_identities
-- where are inserted the new user data for each user creation after each signup.
CREATE OR REPLACE FUNCTION agoston_public.add_user()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    SECURITY DEFINER
AS $BODY$
begin
	insert into agoston_public.users
	select 		  ui.id as "id",
				      coalesce(raw->>'displayName'||' ('||(raw->'_json'->>'email')||')', subject, 'User from '||provider, 'unknown') as "username"
	from 		    agoston_identity.user_identities ui
	left join 	agoston_identity.federated_credentials fc on fc.id = ui.federated_credential_id
	where 		  ui.id = new.id;

  return new;
end;
$BODY$;

-- Create the trigger on the table agoston_identity.user_identities
-- where are inserted the new user data for each user creation after each signup.
CREATE TRIGGER add_user
    AFTER INSERT
    ON agoston_identity.user_identities
    FOR EACH ROW
    EXECUTE FUNCTION agoston_public.add_user();

-- Tables for the application
CREATE TABLE channels (
  id serial PRIMARY KEY,
  name text NOT NULL,
  user_id int NOT NULL,
  CONSTRAINT channel_user_id FOREIGN KEY (user_id) REFERENCES agoston_identity.user_identities (id) ON DELETE CASCADE
);
CREATE INDEX ON channels (user_id);
GRANT SELECT ON channels TO anonymous, authenticated;

CREATE TABLE broadcasts (
  id serial PRIMARY KEY,
  name text NOT NULL,
  channel_id int NOT NULL,
  video_url text NOT NULL,
  live_started_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  live_ended_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  liked int NOT NULL DEFAULT 0,
  json_sample jsonb,
  CONSTRAINT broadcast_channel_id FOREIGN KEY (channel_id) REFERENCES channels (id) ON DELETE CASCADE
);
CREATE INDEX ON broadcasts (channel_id);
GRANT SELECT ON broadcasts TO anonymous, authenticated;

CREATE TABLE chats (
  id serial PRIMARY KEY,
  broadcast_id int NOT NULL,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  user_id int NOT NULL DEFAULT get_current_user_id(),
  content text NOT NULL CONSTRAINT chats_content CHECK (char_length(content) > 0 AND char_length(content) <= 1024),
  CONSTRAINT chat_broadcast_id FOREIGN KEY (broadcast_id) REFERENCES broadcasts (id) ON DELETE CASCADE,
  CONSTRAINT chat_user_id FOREIGN KEY (user_id) REFERENCES agoston_identity.user_identities (id) ON DELETE CASCADE
);
CREATE INDEX ON chats (user_id);
CREATE INDEX chats_broadcast_id ON chats (broadcast_id);
GRANT SELECT ON chats TO anonymous, authenticated;
GRANT INSERT (broadcast_id, content) ON chats TO authenticated;
GRANT USAGE ON SEQUENCE chats_id_seq TO anonymous, authenticated;

CREATE TABLE products (
  id serial PRIMARY KEY,
  channels_id int,
  name text NOT NULL,
  description text NOT NULL,
  price decimal(10, 2),
  CONSTRAINT chat_channels_id FOREIGN KEY (channels_id) REFERENCES channels (id) ON DELETE CASCADE
);
CREATE INDEX products_channels_id ON products (channels_id);
GRANT SELECT ON products TO anonymous, authenticated;

