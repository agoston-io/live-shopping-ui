DO $$
BEGIN
  FOR counter IN 1..100 LOOP
    RAISE NOTICE 'Working on: %', counter;
    -- users
    INSERT INTO users
      VALUES (nextval('users_id_seq'), 'User ' || substring(md5(random()::text)
        FOR 4));
    -- channels
    INSERT INTO channels
      VALUES (nextval('channels_id_seq'), 'Channel ' || substring(md5(random()::text)
        FOR 4), currval('users_id_seq'));
    -- broadcasts
    FOR counter IN 1.. (
      SELECT
        floor(random() * 20))
    LOOP
      INSERT INTO broadcasts
        VALUES (nextval('broadcasts_id_seq'), 'broadcast ' || substring(md5(random()::text)
          FOR 4), currval('channels_id_seq'), 'https://video.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '1 hour', round(CAST((random() * 4999) AS numeric)), ('{"attr1":"' || md5(random()::text) || '", "attr2":"' || md5(random()::text) || '"}')::jsonb);
      -- chat
      FOR counter IN 1.. (
        SELECT
          floor(random() * 10))
      LOOP
        INSERT INTO chats
          VALUES (nextval('chats_id_seq'), currval('broadcasts_id_seq'), CURRENT_TIMESTAMP, 1, substring(md5(random()::text)
            FOR 4) || ' ' || substring(md5(random()::text)
            FOR 4) || ' ' || substring(md5(random()::text)
            FOR 4));
      END LOOP;
    END LOOP;
    -- product
    FOR counter IN 1.. (
      SELECT
        floor(random() * 10))
    LOOP
      INSERT INTO products
        VALUES (nextval('products_id_seq'), currval('channels_id_seq'), 'product ' || substring(md5(random()::text)
          FOR 4), 'product desc ' || substring(md5(random()::text)
          FOR 4), round(CAST((random() * 99) AS numeric), 2));
    END LOOP;
  END LOOP;
END;
$$;

-- Update broadcasts timestamps
DO $$
DECLARE
  f record;
  v_live_started_at timestamp;
BEGIN
  FOR f IN
  SELECT
    id
  FROM
    broadcasts LOOP
      v_live_started_at := (timestamp '2022-01-01 00:00:00' + random() * (CURRENT_TIMESTAMP - timestamp '2022-01-01 00:00:00'));
      UPDATE
        broadcasts
      SET
        live_started_at = v_live_started_at,
        live_ended_at = v_live_started_at + interval '1 hour'
      WHERE
        id = f.id;
    END LOOP;
END;
$$;

-- Update chats timestamps
DO $$
DECLARE
  f record;
  v_broadcast_started_at timestamp;
  v_broadcast_ended_at timestamp;
  v_created_at timestamp;
BEGIN
  FOR f IN
  SELECT
    id,
    broadcast_id
  FROM
    chats LOOP
      SELECT
        live_started_at,
        live_ended_at INTO v_broadcast_started_at,
        v_broadcast_ended_at
      FROM
        broadcasts
      WHERE
        id = f.broadcast_id;
      v_created_at := (v_broadcast_started_at + random() * (v_broadcast_ended_at - v_broadcast_started_at));
      UPDATE
        chats
      SET
        created_at = v_created_at
      WHERE
        id = f.id;
    END LOOP;
END;
$$;

-- Update chat user id with random values
DO $$
DECLARE
  f record;
  v_live_started_at timestamp;
BEGIN
  FOR f IN
  SELECT
    id
  FROM
    chats LOOP
      UPDATE
        chats
      SET
        user_id = (
          SELECT
            id
          FROM
            users
          ORDER BY
            RANDOM()
          LIMIT 1)
    WHERE
      id = f.id;
    END LOOP;
END;
$$;

CREATE OR REPLACE PROCEDURE generate_traffic ()
  AS $$
DECLARE
  f record;
  v_broadcast_started_at timestamp;
  v_broadcast_ended_at timestamp;
  v_created_at timestamp;
  v_live_started_at timestamp;
BEGIN
  -- users
  INSERT INTO users
    VALUES (nextval('users_id_seq'), 'User ' || substring(md5(random()::text)
      FOR 4));
  -- channels
  INSERT INTO channels
    VALUES (nextval('channels_id_seq'), 'Channel ' || substring(md5(random()::text)
      FOR 4), currval('users_id_seq'));
  -- broadcasts
  INSERT INTO broadcasts
    VALUES (nextval('broadcasts_id_seq'), 'broadcast ' || substring(md5(random()::text)
      FOR 4), currval('channels_id_seq'), 'https://video.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '1 hour', round(CAST((random() * 4999) AS numeric)), ('{"attr1":"' || md5(random()::text) || '", "attr2":"' || md5(random()::text) || '"}')::jsonb);
  -- chat
  FOR counter IN 1.. (
    SELECT
      floor(random() * 10))
  LOOP
    INSERT INTO chats
      VALUES (nextval('chats_id_seq'), currval('broadcasts_id_seq'), CURRENT_TIMESTAMP, 1, substring(md5(random()::text)
        FOR 4) || ' ' || substring(md5(random()::text)
        FOR 4) || ' ' || substring(md5(random()::text)
        FOR 4));
  END LOOP;
  -- product
  FOR counter IN 1.. (
    SELECT
      floor(random() * 10))
  LOOP
    INSERT INTO products
      VALUES (nextval('products_id_seq'), currval('channels_id_seq'), 'product ' || substring(md5(random()::text)
        FOR 4), 'product desc ' || substring(md5(random()::text)
        FOR 4), round(CAST((random() * 99) AS numeric), 2));
  END LOOP;
  -- Update chats timestamps
  FOR f IN
  SELECT
    id,
    broadcast_id
  FROM
    chats
  WHERE
    broadcast_id = currval('broadcasts_id_seq')
    LOOP
      SELECT
        live_started_at,
        live_ended_at INTO v_broadcast_started_at,
        v_broadcast_ended_at
      FROM
        broadcasts
      WHERE
        id = f.broadcast_id;
      v_created_at := (v_broadcast_started_at + random() * (v_broadcast_ended_at - v_broadcast_started_at));
      UPDATE
        chats
      SET
        created_at = v_created_at
      WHERE
        id = f.id;
    END LOOP;
  -- Update chat user id with random values
  FOR f IN
  SELECT
    id
  FROM
    chats
  WHERE
    broadcast_id = currval('broadcasts_id_seq')
    LOOP
      UPDATE
        chats
      SET
        user_id = (
          SELECT
            id
          FROM
            users
          ORDER BY
            RANDOM()
          LIMIT 1)
    WHERE
      id = f.id;
    END LOOP;
END;
$$
LANGUAGE plpgsql;

