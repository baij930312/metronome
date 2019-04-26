
# metronome

基于rxdart & bloc pattern 开发的一款支持按小节编辑速度的节拍器

## 截图
![截图](https://github.com/baij930312/metronome/blob/master/readme_img.png)

## 目录

├── agent<br>
│   ├── agent.dart<br>
│   ├── api.dart<br>
│   ├── api_model.dart<br>
│   └── api_model.g.dart<br>
├── app<br>
│   ├── app.dart<br>
│   └── model<br>
│       ├── local_cache_model.dart<br>
│       ├── local_cache_model.g.dart<br>
│       ├── local_store_metronome_model.dart<br>
│       └── local_store_metronome_model.g.dart<br>
├── bloc<br>
│   ├── app_bloc.dart<br>
│   └── bloc_provider.dart<br>
├── common<br>
│   ├── colors.dart<br>
│   ├── images.dart<br>
│   └── utils.dart<br>
├── main.dart<br>
├── player<br>
│   └── player.dart<br>
├── screen<br>
│   ├── home<br>
│   │   ├── home_bloc.dart<br>
│   │   ├── home.dart<br>
│   │   ├── metronome_tile.dart<br>
│   │   └── model<br>
│   │       ├── metronome_model.dart<br>
│   │       ├── metronome_model.g.dart<br>
│   │       ├── play_state.dart<br>
│   │       └── reorder_modeld.dart<br>
│   ├── placeholder<br>
│   │   ├── placeholder_bloc.dart<br>
│   │   └── placeholder_screen.dart<br>
│   └── tab<br>
│       └── tab_screen.dart<br>
└── widget<br>
    ├── backdrop_panel.dart<br>
    ├── bottom_tool_bar.dart<br>
    ├── drag_delete_tile.dart<br>
    ├── fade_appbar.dart<br>
    └── refresh_list_view.dart<br>
