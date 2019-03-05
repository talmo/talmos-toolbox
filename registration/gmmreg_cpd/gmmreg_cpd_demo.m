config = gmmreg_load_config('./fish_full.ini');
config.motion = 'grbf';
config.init_param = zeros(25,2);
[fp,fm] = gmmreg_cpd(config);
DisplayPoints(fm,config.scene,2);


%%
figure
plot(config.scene(:,1),config.scene(:,2),'.', ...
    config.model(:,1),config.model(:,2),'o',...
    config.ctrl_pts(:,1),config.ctrl_pts(:,2),'+',...
    fm(:,1),fm(:,2),'x')

%%
[registered, params, config] = fit_gmmcpd(config.scene, config.model);

%%
figure
plot(config.scene(:,1),config.scene(:,2),'o', ...
    config.model(:,1),config.model(:,2),'.',...
    config.ctrl_pts(:,1),config.ctrl_pts(:,2),'+',...
    registered(:,1),registered(:,2),'x')