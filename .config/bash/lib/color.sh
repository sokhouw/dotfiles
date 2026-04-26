dfg_palette_blue_horizon=(              '#1f2029' '#3b3e4e' '#555b7c' '#6f7d9b' '#a3b8c8')
dfg_palette_shades_of_gray=(            '#1e1e2f' '#2a2a3c' '#3c3c4e' '#686882' '#8b8b9c')
dfg_palette_dark_blue_night=(           '#1e1e2f' '#3a3a4a' '#5c5c7a' '#7b7b9d' '#9f9fc1')
dfg_palette_cosmic_veil=(               '#1d202a' '#2e303d' '#4f505f' '#74757b' '#a4a5a8')
dfg_palette_gray_moon=(                 '#2b2933' '#4b4950' '#7a7882' '#b8b3c2' '#e1e0e5')
dfg_palette_midnight_hailstones=(       '#1e1a3d' '#3a2b69' '#5f3a92' '#9c6dc0' '#d8a3e0')
dfg_palette_mystic_twilight=(           '#3d266e' '#4e3687' '#694fa1' '#8c6dba' '#c7a8e1')
dfg_palette_neptune=(                   '#0a0a1f' '#191938' '#2a2a5a' '#4b4b8b' '#6a6aa9')
dfg_palette_deep_ocean=(                '#0a2343' '#1a3b60' '#2a5a7a' '#3b7b97' '#4a98b0')
dfg_palette_midnight_reverie=(          '#1a1f23' '#2b3d50' '#354a5f' '#5d6d7e' '#7c9ec0')
dfg_palette_celestial_voyage=(          '#1b2a6f' '#2b3e9c' '#4f74b5' '#6e9ed8' '#a3c7e0')
dfg_palette_stormy_night=(              '#0a0f1f' '#2b3a50' '#4b5e7c' '#7b8da3' '#b8c6d6')
dfg_palette_day_woods=(                 '#3c5b2a' '#50713d' '#708c4f' '#99a85d' '#c0c5a5')
dfg_palette_copper_veins=(              '#7d3b2b' '#a45d2d' '#c79c5c' '#e1b06b' '#f6d9a2')
dfg_palette_clockwork_dreams=(          '#794d39' '#b86d4c' '#d8a44b' '#f6cc6a' '#f9e79f')
dfg_palette_moss=(                      '#202f29' '#334232' '#47553a' '#596542' '#6c784b')
dfg_palette_darkwwod=(                  '#2d1810' '#3d261a' '#5c4033' '#8a593d' '#a67859')
dfg_palette_earth=(                     '#2d1810' '#4b2f20' '#8c5a2b' '#d4a573' '#f8e7ce')
dfg_palette_blue_tokyo_night=(          '#1b1f37' '#3e4f75' '#5d8db6' '#f1b350' '#f76e6e')
dfg_palette_sinister_night=(            '#0a0a0f' '#1a1a2e' '#15203c' '#543483' '#b91371')

dfg:color:demo() {
    for p in $(grep "^dfg_palette_" "${BASH_SOURCE}" | cut -d= -f1 | cut -d_ -f3-); do
        if [[ "${palette}" == "${p}" || "${palette}" == "" ]]; then
            declare -n palette_arr="dfg_palette_${p}"
            for (( i = 0; i < ${#palette_arr[@]}; i++ )); do
                dfg:term:bg "${palette_arr[${i}]}"
                if (( i <= 2 )); then fgi=4; else fgi=0; fi
                dfg:term:fg "${palette_arr[${fgi}]}"
                printf ' %s ' "${palette_arr[${i}]}"
                dfg:term:reset
            done
            echo " ${p}"
        fi
    done
}

# dfg:prompt:builtin:palette:dim() { 
#     dfg_prompt_palette=( 
#         "#001133" "#aaaaff" 
#         "#002244" "#ccccff" 
#         "#331100" "#ffaaaa" 
#         "#884400" "#ffcccc" 
#         "#ff8888" "#ffff88" 
#     ) 
# }
#
# dfg:prompt:builtin:palette:midnight_indigo() {
#   dfg_prompt_palette=(
#         '#000a1f' '#6b7cff'
#         '#001433' '#9fb0ff'
#         '#0a0a2a' '#4f63ff'
#         '#111144' '#d2dbff'
#         '#1a1a55' '#b7c3ff'
#     )
# }
#
# dfg:prompt:builtin:palette:soft_periwinkle() {
#     dfg_prompt_palette=(
#         '#1a1a33' '#b0b4ff'
#         '#2a2a55' '#e8eaff'
#         '#3a3a77' '#8c90ff'
#         '#222244' '#6f76ff'
#         '#111133' '#cfd2ff'
#     )
# }
#
# dfg:prompt:builtin:palette:warm_sepia_glow() {
#     dfg_prompt_palette=(
#         '#2a1400' '#ff9650'
#         '#3d1f00' '#ffd9bf'
#         '#5c2e00' '#ff7a33'
#         '#331100' '#ffb08a'
#         '#1f0a00' '#ffe2cf'
#     )
# }
#
# dfg:prompt:builtin:palette:autumn_ember() {
#     dfg_prompt_palette=(
#         '#331a00' '#ff9a3d'
#         '#4d2600' '#ffe1b8'
#         '#663300' '#ff7a1a'
#         '#884400' '#ffb48f'
#         '#261300' '#ffedd9'
#     )
# }
#
# dfg:prompt:builtin:palette:rose_ash() {
#     dfg_prompt_palette=(
#         '#330011' '#ff6fa3'
#         '#4d001a' '#ffd1e4'
#         '#660022' '#ff4f8f'
#         '#22000b' '#ffb5d1'
#         '#110006' '#ffe6f0'
#     )
# }
#
# dfg:prompt:builtin:palette:dusty_lavender() {
#     dfg_prompt_palette=(
#         '#221133' '#a27bff'
#         '#331a55' '#ead9ff'
#         '#442277' '#8b5cff'
#         '#1a0f2a' '#cdb3ff'
#         '#0f081a' '#efe6ff'
#     )
# }
#
# dfg:prompt:builtin:palette:ocean_slate() {
#     dfg_prompt_palette=(
#         '#001f26' '#5fd8ff'
#         '#003340' '#d6f7ff'
#         '#004d66' '#2ecbff'
#         '#002933' '#9be9ff'
#         '#00151a' '#e0faff'
#     )
# }
#
# dfg:prompt:builtin:palette:moss_and_cream() {
#     dfg_prompt_palette=(
#         '#1a2600' '#9dff2e'
#         '#2a4000' '#ebffb8'
#         '#3d5c00' '#7fe600'
#         '#223300' '#c9ff7a'
#         '#111a00' '#f1ffe0'
#     )
# }
#
# dfg:prompt:builtin:palette:copper_blush() {
#     dfg_prompt_palette=(
#         '#331100' '#ff8a66'
#         '#4d1a00' '#ffe1d6'
#         '#662200' '#ff6a3d'
#         '#2a0e00' '#ffc1ad'
#         '#1a0800' '#ffece6'
#     )
# }
#
# dfg:prompt:builtin:palette:solar_pastel() {
#     dfg_prompt_palette=(
#         '#332b00' '#ffd11a'
#         '#4d4000' '#fff2b3'
#         '#665500' '#ffbf00'
#         '#261f00' '#ffe680'
#         '#1a1400' '#fff0c9'
#     )
# }
#
# dfg:prompt:builtin:palette:industrial() {
#     dfg_prompt_palette=(
#         '#1a1a1a' '#bfbfbf'
#         '#262626' '#e0e0e0'
#         '#333333' '#9fa6ad'
#         '#404040' '#cfd6dc'
#         '#4d4d4d' '#f0f2f4'
#     )
# }
#
# dfg:prompt:builtin:palette:old_city() {
#     dfg_prompt_palette=(
#         '#2b1d14' '#e0c2a2'
#         '#3a261a' '#f2d8bd'
#         '#4a3224' '#d4b08c'
#         '#5c4030' '#ebcfae'
#         '#6f523f' '#f7eadb'
#     )
# }
#
# dfg:prompt:builtin:palette:dark_wood() {
#     dfg_prompt_palette=(
#         '#1f140a' '#d2b48c'
#         '#2d1d12' '#e6c9a8'
#         '#3b2718' '#b9966e'
#         '#4a3220' '#dec3a1'
#         '#5a402b' '#f0e0cf'
#     )
# }
#
# dfg:prompt:builtin:palette:fire() {
#     dfg_prompt_palette=(
#         '#330000' '#ff6a00'
#         '#4d0000' '#ff9a3d'
#         '#660000' '#ff3d00'
#         '#802000' '#ffb36b'
#         '#992f00' '#ffd2a3'
#     )
# }
#
# dfg:prompt:builtin:palette:iceberg() {
#     dfg_prompt_palette=(
#         '#001a1f' '#6fe7ff'
#         '#002830' '#a6f3ff'
#         '#003d4a' '#2fd6ff'
#         '#005466' '#8feeff'
#         '#006b80' '#d9fbff'
#     )
# }
#
# dfg:prompt:builtin:palette:winter_night() {
#     dfg_prompt_palette=(
#         '#0b1020' '#8fa8ff'
#         '#121a33' '#b3c5ff'
#         '#1a244d' '#6f8cff'
#         '#232f66' '#cfd9ff'
#         '#2d3a80' '#e6ecff'
#     )
# }
#
# dfg:prompt:builtin:palette:moonlight() {
#     dfg_prompt_palette=(
#         '#0f111a' '#aab0c8'
#         '#181b26' '#d0d5f0'
#         '#22263a' '#8f97c8'
#         '#2c314d' '#bcc3ff'
#         '#373d66' '#e4e8ff'
#     )
# }
#

