function readFile(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Ошибка: не могу открыть " .. filename)
        return nil
    end

    local dna = ""
    for line in file:lines() do
        if not line:match("^>") then 
            dna = dna .. line:gsub("[%d%s]", "") 
        end
    end
    file:close()
    return dna
end

-- 7: Найти минимальную специфичную последовательность для (1), отсутствующую в (2)
-- 13: Найти минимальную специфичную последовательность для (1), отсутствующую в (3) и (2)
function find_unique(data1, data2)
    local max_len = math.min(#data1, 6) 
    for len = 1, max_len do
        for i = 1, #data1 - len + 1 do --нач позиции
            local sub = data1:sub(i, i + len - 1)
            if not data2:find(sub, 1, true) then 
                return sub
            end
        end
    end
    return nil
end

-- 9: Найти минимальную общую последовательность для (1) и (2)
function find_common(data1, data2)
    local max_len = math.min(#data1, #data2, 6)  
    for len = 1, max_len do
        for i = 1, #data1 - len + 1 do
            local sub = data1:sub(i, i + len - 1)
            if data2:find(sub, 1, true) then
                return sub
            end
        end
    end
    return nil
end

-- 15: Найти максимальную общую подпоследовательность для (1) и (3)
function find_lcs(data1, data2)
    local longest = ""
    
    for i = 1, #data1 do
        for j = i, #data1 do
            if j - i + 1 > #longest then
                local substring = data1:sub(i, j)
                if data2:find(substring, 1, true) then
                    longest = substring
                end
            end
        end
    end
    
    return longest
end

local covid_wuhan = readFile("origin1.txt")
local h5n1 = readFile("origin2.txt")
local covid_delta = readFile("origin3.txt")

if not covid_wuhan or not h5n1 or not covid_delta then
    print("Ошибка: один или несколько файлов не загружены.")
    os.exit(1)
end
covid_wuhan = covid_wuhan:sub(1, 10000)
h5n1 = h5n1:sub(1, 5000)
covid_delta = covid_delta:sub(1, 10000)

local unique_covid = find_unique(covid_wuhan, h5n1)
local unique_h5n1 = find_unique(h5n1, covid_wuhan)
local common_covid_h5n1 = find_common(covid_wuhan, h5n1)

local unique_covid_all = find_unique(covid_wuhan, h5n1 .. covid_delta)
local unique_delta_all = find_unique(covid_delta, covid_wuhan .. h5n1)

local common_covid_delta = find_lcs(covid_wuhan, covid_delta)
local ratio_common = #common_covid_delta / #covid_wuhan


print("1. Уникальная последовательность COVID-19 (Wuhan), отсутствующая в H5N1:")
print(unique_covid)
print("2. Уникальная последовательность H5N1, отсутствующая в COVID-19 (Wuhan):")
print(unique_h5n1)
print("3. Минимальная общая последовательность COVID-19 (Wuhan) и H5N1:")
print(common_covid_h5n1)
print("4. Уникальная последовательность COVID-19 (Wuhan), отсутствующая в H5N1 и Delta:")
print(unique_covid_all)
print("5. Уникальная последовательность COVID-19 (Delta), отсутствующая в H5N1 и Wuhan:")
print(unique_delta_all)
print("6. Максимальная общая подпоследовательность COVID-19 (Wuhan) и Delta:")
print(common_covid_delta)
print("7. Соотношение длины общей подпоследовательности к длине генома COVID-19 (Wuhan):")
print(ratio_common)
