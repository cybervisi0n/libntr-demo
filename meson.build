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

if(build_target == 'prospero')
    subdir('prospero')
endif

############################################################
###                      LINK ARGS                       ###
############################################################
project_link_args = []
project_libs = []
if(build_target == 'arm')
    project_link_args += [
        'spec/main.lcf'
    ]
endif
if(build_target == 'prospero')
project_link_args += [
    '-nostartfiles',
    '-T' + meson.global_source_root() + '/' + 'prospero/ps5-elf.ld',
    '-e',
    '_start',
    '-Wl,--version-script=' + meson.global_source_root() + '/' + 'prospero/ps5-app-symbols.map',
    '-pthread'
]

project_libs += prospero_crt_lib
endif

############################################################
###                     ARM9 BINARY                      ###
############################################################
subdir('src')

main_exe = executable('main',
    sources: project_srcs,
    include_directories: project_includes,
    dependencies: project_deps,
    link_args: project_link_args,
    link_with: project_libs,
    native: (build_target == 'linux' or build_target == 'win64')
)

if(build_target == 'prospero')
############################################################
###                  PROSPERO AUTHORING                  ###
############################################################
eboot_elf = custom_target(
    'eboot.elf',
    output: 'eboot.elf',
    depends: [
        main_exe, 
        sce_agc_lib, 
        sce_agc_driver_lib
    ],
    command: [
        ps5_native_tool_exe,
        'link',
        '--in',
        main_exe,
        '--out',
        '@OUTPUT@',
        '--stub-dir',
        meson.global_source_root() + '/prospero-deps/ps5-payload-sdk/target/lib',
        '--stub',
        sce_agc_lib,
        '--stub',
        sce_agc_driver_lib,
        '--module-sdk',
        '0x02000009',
        '--companion_sdk',
        '0x08050001',
        '--file-name',
        'eboot.elf'
    ]
)

# Sign eboot.elf to eboot.bin
eboot_bin = custom_target(
    'eboot.bin',
    output: 'eboot.bin',
    depends: [eboot_elf],
    command: [ ps5_native_tool_exe, 
               'self',
               '--sign',
               '--in',
               eboot_elf,
               '--out',
               '@OUTPUT@' ]
)

# Generate libc.prx stub (required by PS5 loader)
libc_prx = custom_target(
    'libc.prx',
    output: 'libc.prx',
    depends: [libc_elf],
    command: [ ps5_native_tool_exe, 
               'self',
               '--sign',
               '--in',
               libc_elf,
               '--out',
               '@OUTPUT@' ]
)

# Build the app folder
build_app_folder_sh = files('scripts/build_ps5_folder.sh')
sce_sys_source = meson.project_source_root() + '/prospero/sce_sys'
app_folder = custom_target(
    'PPSA94600',
    output: 'PPSA94600',
    build_by_default: true,
    depends: [libc_prx, eboot_bin],
    command: [
        build_app_folder_sh,
        meson.project_source_root(),
        eboot_bin,
        libc_prx,
        sce_sys_source,
        '@OUTPUT@'
    ]
)
endif # build_target == 'prospero'