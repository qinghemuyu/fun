function Effect( Event )
  
  if ( Event:GetName() == 'player_death' ) then
      
      local ME = client.GetLocalPlayerIndex();
      
      local INT_UID = Event:GetInt( 'userid' );
      local INT_ATTACKER = Event:GetInt( 'attacker' );
      
      local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
      local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );
      
      local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
      local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );
      
      if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then
      entities.GetLocalPlayer():SetProp("m_flHealthShotBoostExpirationTime", globals.CurTime() + 1)
                    client.Command("playvol physics\\glass\\glass_pottery_break2 .5", true);
      
      end
  
  end
  
end

client.AllowListener( 'player_death' );

callbacks.Register( 'FireGameEvent', 'AWKS', Effect );