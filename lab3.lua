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

function find_unique(data1, data2)
  local max_len = #data1 
    for len = 1, max_len do
        for i = 1, #data1 - len + 1 do
            local sub = data1:sub(i, i + len - 1)
            local found = false
            for j = 1, #data2 - len + 1 do
                if data2:sub(j, j + len - 1) == sub then
                    found = true
                    break
                end
            end
            if not found then
                return sub  
            end
        end
    end
    return nil  
end

function find_lcs(data1, data2)
    local m, n = #data1, #data2
    local prev = {}
    local curr = {}
    for j = 0, n do prev[j] = 0 end

    local maxLength, endIndex = 0, 0

    for i = 1, m do
        curr = {}
        curr[0] = 0
        for j = 1, n do
            if data1:sub(i, i) == data2:sub(j, j) then
                curr[j] = prev[j - 1] + 1
                if curr[j] > maxLength then
                    maxLength, endIndex = curr[j], i
                end
            else
                curr[j] = 0
            end
        end
        prev = curr
    end

    if maxLength == 0 then return "" end
    return data1:sub(endIndex - maxLength + 1, endIndex)
end

local covid_wuhan = readFile("origin1.txt")
local h5n1 = readFile("origin2.txt")
local covid_delta = readFile("origin3.txt")

if not covid_wuhan or not h5n1 or not covid_delta then
    print("Ошибка: один или несколько файлов не загружены.")
    os.exit(1)
end

covid_wuhan = covid_wuhan:sub(1, 5000)
h5n1 = h5n1:sub(1, 5000)
covid_delta = covid_delta:sub(1, 5000)

local unique_covid = find_unique(covid_wuhan, h5n1)
local unique_h5n1 = find_unique(h5n1, covid_wuhan)
local common_covid_h5n1 = find_lcs(covid_wuhan, h5n1)

local unique_covid_all = find_unique(covid_wuhan, h5n1 .. covid_delta)
local unique_delta_all = find_unique(covid_delta, covid_wuhan .. h5n1)
local common_covid_delta = find_lcs(covid_wuhan, covid_delta)
local ratio_common = (#common_covid_delta) / (#covid_wuhan)

print("Уникальная последовательность COVID-19 (Wuhan), отсутствующая в H5N1:", unique_covid)
print("Уникальная последовательность H5N1, отсутствующая в COVID-19 (Wuhan):", unique_h5n1)
print("Общая последовательность COVID-19 (Wuhan) и H5N1:", common_covid_h5n1)
print("Уникальная последовательность COVID-19 (Wuhan), отсутствующая в H5N1 и Delta:", unique_covid_all)
print("Уникальная последовательность COVID-19 (Delta), отсутствующая в H5N1 и Wuhan:", unique_delta_all)
print("Общая последовательность COVID-19 (Wuhan) и Delta:", common_covid_delta)
print("Соотношение длины общей последовательности к длине генома COVID-19 (Wuhan):", ratio_common)
