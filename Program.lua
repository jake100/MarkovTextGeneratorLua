MarkovTextGenerator = {}

function MarkovTextGenerator:new(text, order)
    order = order or 2
    local ngrams = {}
    local self = {text = text, order = order, ngrams = ngrams}
    setmetatable(self, {__index = MarkovTextGenerator})
    self:build_ngrams()
    return self
end

function MarkovTextGenerator:build_ngrams()
    local words = string.split(self.text, " ")
    for i = 1, #words - self.order do
        local ngram = {}
        for j = i, i + self.order - 1 do
            ngram[j - i + 1] = words[j]
        end
        ngram = table.concat(ngram, " ")
        if not self.ngrams[ngram] then self.ngrams[ngram] = {} end
        local next_word = words[i + self.order]
        table.insert(self.ngrams[ngram], next_word)
    end
end

function MarkovTextGenerator:generate_text(length)
    local current_ngram = self.ngrams[math.random(#self.ngrams)]
    local generated_text = current_ngram
    for i = 1, length - self.order do
        local next_word = self.ngrams[current_ngram][math.random(#self.ngrams[current_ngram])]
        generated_text = generated_text .. " " .. next_word
        current_ngram = string.sub(generated_text, -self.order)
    end
    return generated_text
end

text = "This is an example of a Markov text generator. It is written in Lua."
gen = MarkovTextGenerator:new(text)
print(gen:generate_text(10))
