CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username text NOT NULL
);
GRANT select ON users TO anonymous, authenticated;

CREATE OR REPLACE FUNCTION get_random_user_id() RETURNS int LANGUAGE SQL AS
$$ SELECT id FROM users ORDER BY RANDOM () limit 1; $$;

CREATE TABLE channels (
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  user_id int not null,
  constraint channel_user_id foreign key(user_id) references users(id) on delete cascade
);
CREATE INDEX ON channels(user_id);
GRANT select ON channels TO anonymous, authenticated;

CREATE TABLE broadcasts (
  id SERIAL PRIMARY KEY,
  name text NOT NULL,
  channel_id int not null,
  video_url text NOT NULL,
  live_started_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  live_ended_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  liked int not null default 0,
  json_sample jsonb,
  constraint broadcast_channel_id foreign key(channel_id) references channels(id) on delete cascade
);
CREATE INDEX ON broadcasts(channel_id);
GRANT select ON broadcasts TO anonymous, authenticated;

CREATE TABLE chats (
  id SERIAL PRIMARY KEY,
  broadcast_id int not null,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
  user_id int not null default get_random_user_id(),
  content text not null constraint chats_content check (char_length(content)> 0 and char_length(content) <= 1024),
  constraint chat_broadcast_id foreign key(broadcast_id) references broadcasts(id) on delete cascade,
  constraint chat_user_id foreign key(user_id) references users(id) on delete cascade
);
comment on table chats is E'@recaptcha true';
CREATE INDEX ON chats(user_id);
CREATE INDEX chats_broadcast_id ON chats (broadcast_id);
GRANT select ON chats TO anonymous, authenticated;
GRANT insert (broadcast_id, content) ON chats TO anonymous, authenticated;
GRANT USAGE ON SEQUENCE chats_id_seq TO anonymous, authenticated;
-- Enable subscription on column change by id
CREATE TRIGGER subscriptions_chats_broadcast_id
  AFTER INSERT OR UPDATE OR DELETE ON chats
  FOR EACH ROW
  EXECUTE PROCEDURE agoston_api.graphql_subscription('broadcast_id');
--

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  channels_id int,
  name text NOT NULL,
  description text NOT NULL,
  price decimal(10,2),
  constraint chat_channels_id foreign key(channels_id) references channels(id) on delete cascade
);
CREATE INDEX products_channels_id ON products (channels_id);
GRANT select ON products TO anonymous, authenticated;


-- TARGET: Mockup data
do $$
begin
  for counter in 1..100 loop
	  raise notice 'Working on: %', counter;
    -- users
    insert into users values
      (
        nextval('users_id_seq'),
        'User '||substring(md5(random()::text) for 4)
      );
    -- channels
    insert into channels values
      (
        nextval('channels_id_seq'),
        'Channel '||substring(md5(random()::text) for 4),
        currval('users_id_seq')
      );
    -- broadcasts
    for counter in 1..(select floor(random() * 20)) loop
    insert into broadcasts values
      (
        nextval('broadcasts_id_seq'),
        'broadcast '||substring(md5(random()::text) for 4),
        currval('channels_id_seq'),
        'https://video.com',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP + interval '1 hour',
        round( CAST((random() * 4999 ) as numeric)),
        ('{"attr1":"' ||  md5(random()::text) || '", "attr2":"' || md5(random()::text) ||'"}')::jsonb
      );
          -- chat
      for counter in 1..(select floor(random() * 10)) loop
        insert into chats values
          (
            nextval('chats_id_seq'),
            currval('broadcasts_id_seq'),
            CURRENT_TIMESTAMP,
            1,
            substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)
          );
      end loop;
    end loop;
    -- product
    for counter in 1..(select floor(random() * 10)) loop
      insert into products values
        (
          nextval('products_id_seq'),
          currval('channels_id_seq'),
          'product '||substring(md5(random()::text) for 4),
          'product desc '||substring(md5(random()::text) for 4),
          round( CAST((random() * 99 ) as numeric), 2)
        );
    end loop;
  end loop;
end;
$$;

-- Update broadcasts timestamps
do
$$
declare
    f record;
    v_live_started_at timestamp;
begin
    for f in select id from broadcasts loop
      v_live_started_at := (timestamp '2022-01-01 00:00:00' +
            random() * (CURRENT_TIMESTAMP - timestamp '2022-01-01 00:00:00')
          );
	    update broadcasts set
        live_started_at = v_live_started_at,
        live_ended_at = v_live_started_at + interval '1 hour'
        where id = f.id;
    end loop;
end;
$$;
-- Update chats timestamps
do
$$
declare
    f record;
    v_broadcast_started_at timestamp;
    v_broadcast_ended_at timestamp;
    v_created_at timestamp;
begin
    for f in select id, broadcast_id from chats loop
      select live_started_at, live_ended_at into v_broadcast_started_at, v_broadcast_ended_at
      from broadcasts
      where id = f.broadcast_id;
      v_created_at := (v_broadcast_started_at +
            random() * (v_broadcast_ended_at - v_broadcast_started_at)
          );
	    update chats set
        created_at = v_created_at
        where id = f.id;
    end loop;
end;
$$;
-- Update chat user id with random values
do
$$
declare
    f record;
    v_live_started_at timestamp;
begin
    for f in select id from chats loop
	    update chats set
        user_id = (SELECT id FROM users ORDER BY RANDOM () limit 1)
        where id = f.id;
    end loop;
end;
$$;

create or replace procedure generate_traffic()
as $$
declare
    f record;
    v_broadcast_started_at timestamp;
    v_broadcast_ended_at timestamp;
    v_created_at timestamp;
    v_live_started_at timestamp;
begin
    -- users
    insert into users values
      (
        nextval('users_id_seq'),
        'User '||substring(md5(random()::text) for 4)
      );
    -- channels
    insert into channels values
      (
        nextval('channels_id_seq'),
        'Channel '||substring(md5(random()::text) for 4),
        currval('users_id_seq')
      );
    -- broadcasts
    insert into broadcasts values
    (
      nextval('broadcasts_id_seq'),
      'broadcast '||substring(md5(random()::text) for 4),
      currval('channels_id_seq'),
      'https://video.com',
      CURRENT_TIMESTAMP,
      CURRENT_TIMESTAMP + interval '1 hour',
      round( CAST((random() * 4999 ) as numeric)),
      ('{"attr1":"' ||  md5(random()::text) || '", "attr2":"' || md5(random()::text) ||'"}')::jsonb
    );
    -- chat
    for counter in 1..(select floor(random() * 10)) loop
      insert into chats values
        (
          nextval('chats_id_seq'),
          currval('broadcasts_id_seq'),
          CURRENT_TIMESTAMP,
          1,
          substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)
        );
    end loop;
    -- product
    for counter in 1..(select floor(random() * 10)) loop
      insert into products values
        (
          nextval('products_id_seq'),
          currval('channels_id_seq'),
          'product '||substring(md5(random()::text) for 4),
          'product desc '||substring(md5(random()::text) for 4),
          round( CAST((random() * 99 ) as numeric), 2)
        );
    end loop;

    -- Update chats timestamps
    for f in select id, broadcast_id
            from chats
            where broadcast_id = currval('broadcasts_id_seq') loop
      select live_started_at, live_ended_at into v_broadcast_started_at, v_broadcast_ended_at
      from broadcasts
      where id = f.broadcast_id;
      v_created_at := (v_broadcast_started_at +
            random() * (v_broadcast_ended_at - v_broadcast_started_at)
          );
      update chats set
        created_at = v_created_at
        where id = f.id;
    end loop;

    -- Update chat user id with random values
    for f in select id
            from chats
            where broadcast_id = currval('broadcasts_id_seq') loop
      update chats set
        user_id = (SELECT id FROM users ORDER BY RANDOM () limit 1)
        where id = f.id;
    end loop;
end;
$$ language plpgsql;
