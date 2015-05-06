class Genepool < Array
  def roulette(n, quality = :fitness)
    scratch = self.clone

    probabilities = scratch.map { |creature| creature.send(quality) }
    selected = []

    n.times do
      r, inc = rand * probabilities.max, 0 # pick a random number and select the  individual
                       # corresponding to that roulette-wheel area
      scratch.each_index do |i|
        if r < (inc += probabilities[i])
          selected << scratch[i]
          # make selection not pick sample twice
          # scratch.delete_at i
          # probabilities.delete_at i
          break
        end
      end
    end
    return selected
  end

  def generate(n, mutationRate = 0.01, quality = :fitness)
    scratch = self.clone

    pool = scratch.roulette(n * 2, quality)

    generation = Genepool.new

    pool.each_slice(2) do |pair|
      child = pair[0] << pair[1]
      # child = child.mutate if mutationRate > 0
      generation << child
    end

    return generation
  end

  def average(quality = :fitness)
    self.map {|f| f.send(quality)}.inject{ |sum, n| sum + n }.to_f / self.length
  end
end


