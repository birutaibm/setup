#!/usr/bin/env fish

echo "# Configuração atual do Tide"
echo "# Copie e cole no seu ~/.config/fish/config.fish"
echo

echo "if status is-interactive"

# Processar arrays especiais primeiro
set -l special_arrays tide_left_prompt_items tide_right_prompt_items

for array_name in $special_arrays
    set -l values $$array_name
    set -l values_str ""
    for val in $values
        set values_str "$values_str $val"
    end
    set values_str (string trim "$values_str")
    echo "    set -g $array_name $values_str"
end

# Processar todas as outras variáveis Tide
set -l tide_vars (set -n | grep '^tide_' | grep -v '^tide_left_prompt_items$' | grep -v '^tide_right_prompt_items$' | sort)

for var in $tide_vars
    # Pular variáveis que não existem ou são funções
    if not set -q $var; or functions -q $var
        continue
    end
    
    # Verificar se é um array
    set -l values $$var
    if test (count $values) -gt 1
        set -l values_str ""
        for val in $values
            # Escape de strings
            if string match -q -- "*[[:space:]]*" "$val" 
                set values_str "$values_str \"$val\""
            else
                set values_str "$values_str $val"
            end
        end
        set values_str (string trim "$values_str")
        echo "    set -g $var $values_str"
    else
        # String única
        if string match -q -- "*[[:space:]]*" "$values"; or test -z "$values"
            echo "    set -g $var \"$values\""
        else
            echo "    set -g $var $values"
        end
    end
end

echo "end"
