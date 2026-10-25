project('libntr-demo', ['c', 'cpp'],
    version: '1.0',
)

fs = import('fs')
build_target = get_option('build_target')

############################################################
###                    INCLUDE PATHS                     ###
############################################################
project_includes = include_directories('include')

############################################################
###                     DEPENDENCIES                     ###
############################################################
libntr_prj = subproject('libntr',
    default_options: [
        'card_game_code=LNTR',
        'card_maker_code=99'
    ])
libntr_dep = dependency('NitroSDK')
libntrsystem_dep = dependency('NitroSystem')
libntrwifi_dep = dependency('NitroWiFi')
libntrdwc_dep = dependency('NitroDWC')

project_deps = [
    libntr_dep,
    libntrsystem_dep,
    libntrwifi_dep,
    libntrdwc_dep
]

if(build_target == 'win64')
    ws2_32_lib = meson.get_compiler('c').find_library('ws2_32')
    ws2_32_dep = declare_dependency(dependencies: [ws2_32_lib])
    project_deps += ws2_32_dep
endif

############################################################
###                      LINK ARGS                       ###
############################################################
project_link_args = []
if(build_target == 'arm')
    project_link_args += [
        'spec/main.lcf'
    ]
endif

############################################################
###                     ARM9 BINARY                      ###
############################################################
subdir('src')

main = executable('main',
    sources: project_srcs,
    include_directories: project_includes,
    dependencies: project_deps,
    link_args: project_link_args,
    native: (build_target == 'linux' or build_target == 'win64')
)
