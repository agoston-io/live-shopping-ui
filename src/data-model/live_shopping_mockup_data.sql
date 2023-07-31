create or replace procedure generate_traffic ()
  as $$
declare
  f record;
  v_user_id int;
  v_broadcast_started_at timestamp;
  v_broadcast_ended_at timestamp;
  v_created_at timestamp;
  v_live_started_at timestamp;
begin
  -- Pickup a random user
  select id
  into v_user_id
  from agoston_identity.user_identities
  order by random() limit 1;

  -- channels
  insert into channels values (
    nextval('channels_id_seq'),
    'Channel ' || substring(md5(random()::text) FOR 4),
    v_user_id
  );
  -- broadcasts
  insert into broadcasts values (
    nextval('broadcasts_id_seq'),
    'broadcast ' || substring(md5(random()::text) FOR 4),
    currval('channels_id_seq'),
    'https://video.com',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + interval '1 hour',
    round(CAST((random() * 4999) AS numeric)),
    ('{"attr1":"' || md5(random()::text) || '", "attr2":"' || md5(random()::text) || '"}')::jsonb
  );
  -- chats
  for counter in 1.. ( select floor(random() * 10)) LOOP
    insert into chats values (
      nextval('chats_id_seq'),
      currval('broadcasts_id_seq'),
      CURRENT_TIMESTAMP,
      v_user_id,
      substring(md5(random()::text) FOR 4) || ' ' || substring(md5(random()::text) FOR 4) || ' ' || substring(md5(random()::text) FOR 4)
    );
  END LOOP;
  -- products
  for counter in 1.. ( select floor(random() * 10)) loop
    insert into products values (
      nextval('products_id_seq'),
      currval('channels_id_seq'),
      'product ' || substring(md5(random()::text) FOR 4), 'product desc ' || substring(md5(random()::text) FOR 4), round(CAST((random() * 99) AS numeric), 2)
    );
  end loop;
  -- Update chats timestamps
  for f in (select id, broadcast_id from chats where broadcast_id = currval('broadcasts_id_seq')) loop
      select  live_started_at,  live_ended_at
      into    v_broadcast_started_at, v_broadcast_ended_at
      from    broadcasts
      where   id = f.broadcast_id;

      v_created_at := (v_broadcast_started_at + random() * (v_broadcast_ended_at - v_broadcast_started_at));

      update  chats
      set     created_at = v_created_at
      where   id = f.id;
  end loop;
  -- Update chat user id with random values
  for f in (select id from chats where broadcast_id = currval('broadcasts_id_seq')) loop
    update chats
    set    user_id = (
              select  id
              from agoston_identity.user_identities
              order by random()
              limit 1)
    where   id = f.id;
  end loop;
end;
$$
language plpgsql;

