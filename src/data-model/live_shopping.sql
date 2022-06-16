CREATE TABLE users (
  id serial PRIMARY KEY,
  username text NOT NULL
);

GRANT SELECT ON users TO anonymous, authenticated;

CREATE OR REPLACE FUNCTION get_random_user_id ()
  RETURNS int
  LANGUAGE SQL
  AS $$
  SELECT
    id
  FROM
    users
  ORDER BY
    RANDOM()
  LIMIT 1;

$$;

CREATE TABLE channels (
  id serial PRIMARY KEY,
  name text NOT NULL,
  user_id int NOT NULL,
  CONSTRAINT channel_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
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
  user_id int NOT NULL DEFAULT get_random_user_id (),
  content text NOT NULL CONSTRAINT chats_content CHECK (char_length(content) > 0 AND char_length(content) <= 1024),
  CONSTRAINT chat_broadcast_id FOREIGN KEY (broadcast_id) REFERENCES broadcasts (id) ON DELETE CASCADE,
  CONSTRAINT chat_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

COMMENT ON TABLE chats IS E'@recaptcha true';

CREATE INDEX ON chats (user_id);

CREATE INDEX chats_broadcast_id ON chats (broadcast_id);

GRANT SELECT ON chats TO anonymous, authenticated;

GRANT INSERT (broadcast_id, content) ON chats TO anonymous, authenticated;

GRANT USAGE ON SEQUENCE chats_id_seq
  TO anonymous, authenticated;

-- Enable subscription on column change by id
CREATE TRIGGER subscriptions_chats_broadcast_id
  AFTER INSERT OR UPDATE OR DELETE ON chats
  FOR EACH ROW
  EXECUTE PROCEDURE agoston_api.graphql_subscription ('broadcast_id');

--
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

