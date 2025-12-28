declare dfg_palette_midnight_reverie=(          '#1a1f23' '#2b3d50' '#354a5f' '#5d6d7e' '#7c9ec0')
declare dfg_palette_dark_blue_horizon=(         '#1f2029' '#3b3e4e' '#555b7c' '#6f7d9b' '#a3b8c8')
declare dfg_palette_shades_of_blue=(            '#1e1e2f' '#2a2a3c' '#3c3c4e' '#686882' '#8b8b9c')
declare dfg_palette_dark_blue_night=(           '#1e1e2f' '#3a3a4a' '#5c5c7a' '#7b7b9d' '#9f9fc1')
declare dfg_palette_cosmic_veil=(               '#1d202a' '#2e303d' '#4f505f' '#74757b' '#a4a5a8')
declare dfg_palette_dark_gray_moon=(            '#2b2933' '#4b4950' '#7a7882' '#b8b3c2' '#e1e0e5')
declare dfg_palette_midnight_hailstones=(       '#1e1a3d' '#3a2b69' '#5f3a92' '#9c6dc0' '#d8a3e0')
declare dfg_palette_mystic_twilight=(           '#3d266e' '#4e3687' '#694fa1' '#8c6dba' '#c7a8e1')
declare dfg_palette_celestial_voyage=(          '#1b2a6f' '#2b3e9c' '#4f74b5' '#6e9ed8' '#a3c7e0')
declare dfg_palette_day_woods=(                 '#3c5b2a' '#50713d' '#708c4f' '#99a85d' '#c0c5a5')
declare dfg_palette_copper_veins=(              '#7d3b2b' '#a45d2d' '#c79c5c' '#e1b06b' '#f6d9a2')
declare dfg_palette_copper_clockwork_dreams=(   '#794d39' '#b86d4c' '#d8a44b' '#f6cc6a' '#f9e79f')
declare dfg_palette_gradient_dark_blue=(        '#c58d6c' '#d3a287' '#e0b8a2' '#edcebd' '#f9e5d9')
declare dfg_palette_moss=(                      '#202f29' '#334232' '#47553a' '#596542' '#6c784b')
declare dfg_palette_darkwwod=(                  '#2d1810' '#3d261a' '#5c4033' '#8a593d' '#a67859')
declare dfg_palette_neptune=(                   '#0a0a1f' '#191938' '#2a2a5a' '#4b4b8b' '#6a6aa9')
declare dfg_palette_deep_ocean=(                '#0a2343' '#1a3b60' '#2a5a7a' '#3b7b97' '#4a98b0')
declare dfg_palette_earth=(                     '#2d1810' '#4b2f20' '#8c5a2b' '#d4a573' '#f8e7ce')
declare dfg_palette_stormy_night=(              '#0a0f1f' '#2b3a50' '#4b5e7c' '#7b8da3' '#b8c6d6')
declare dfg_palette_blue_tokyo_night=(          '#1b1f37' '#3e4f75' '#5d8db6' '#f1b350' '#f76e6e')
declare dfg_palette_sinister_night=(            '#0a0a0f' '#1a1a2e' '#15203c' '#543483' '#b91371')

dfg:color:demo() {
    for p in $(grep "^declare dfg_palette_" "${BASH_SOURCE}" | cut -d' ' -f2 | cut -d= -f1 | cut -d_ -f3-); do
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
