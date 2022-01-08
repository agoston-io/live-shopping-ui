set role backend_a2c360b4_f88b_468d_8f5e_c833fc539449_postgraphile;

-- TARGET: Mockup data
do $$
begin
  -- live_shopping_ui.users
  insert into live_shopping_ui.users values
    (
      nextval('live_shopping_ui.users_id_seq'),
      'User '||substring(md5(random()::text) for 4)
    );
  -- live_shopping_ui.channels
  insert into live_shopping_ui.channels values
    (
      nextval('live_shopping_ui.channels_id_seq'),
      'Channel '||substring(md5(random()::text) for 4),
      currval('live_shopping_ui.users_id_seq')
    );
  -- live_shopping_ui.broadcasts
  insert into live_shopping_ui.broadcasts values
  (
    nextval('live_shopping_ui.broadcasts_id_seq'),
    'broadcast '||substring(md5(random()::text) for 4),
    currval('live_shopping_ui.channels_id_seq'),
    'https://video.com',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + interval '1 hour',
    round( CAST((random() * 4999 ) as numeric)),
    ('{"attr1":"' ||  md5(random()::text) || '", "attr2":"' || md5(random()::text) ||'"}')::jsonb
  );
  -- live_shopping_ui.chat
  for counter in 1..(select floor(random() * 10)) loop
    insert into live_shopping_ui.chats values
      (
        nextval('live_shopping_ui.chats_id_seq'),
        currval('live_shopping_ui.broadcasts_id_seq'),
        CURRENT_TIMESTAMP,
        1,
        substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)||' '||substring(md5(random()::text) for 4)
      );
  end loop;
  -- live_shopping_ui.product
  for counter in 1..(select floor(random() * 10)) loop
    insert into live_shopping_ui.products values
      (
        nextval('live_shopping_ui.products_id_seq'),
        currval('live_shopping_ui.channels_id_seq'),
        'product '||substring(md5(random()::text) for 4),
        'product desc '||substring(md5(random()::text) for 4),
        round( CAST((random() * 99 ) as numeric), 2)
      );
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
    for f in select id, broadcast_id
             from live_shopping_ui.chats
             where broadcast_id = currval('live_shopping_ui.broadcasts_id_seq') loop
      select live_started_at, live_ended_at into v_broadcast_started_at, v_broadcast_ended_at
      from live_shopping_ui.broadcasts
      where id = f.broadcast_id;
      v_created_at := (v_broadcast_started_at +
            random() * (v_broadcast_ended_at - v_broadcast_started_at)
          );
	    update live_shopping_ui.chats set
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
    for f in select id
             from live_shopping_ui.chats
             where broadcast_id = currval('live_shopping_ui.broadcasts_id_seq') loop
	    update live_shopping_ui.chats set
        user_id = (SELECT id FROM live_shopping_ui.users ORDER BY RANDOM () limit 1)
        where id = f.id;
    end loop;
end;
$$;
