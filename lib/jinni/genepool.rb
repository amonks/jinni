class Jinni::Genepool < Array

  # this utility method uses weighted roulette wheel selection to
  # choose `n` objects from your gene pool influenced by fitness.
  # It does not cross them.
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

  # use this method to create a new generation of `n` creatures based
  # on a genepool. it uses weighted roulette wheel selection to simulate
  # the effects of genetic fitness, then crosses the selected objects
  # together.
  def generate(n, mutationRate = 0.01, quality = :fitness)
    scratch = self.clone

    pool = scratch.roulette(n * 2, quality)

    generation = Jinni::Genepool.new

    pool.each_slice(2) do |pair|
      child = pair[0] << pair[1]
      (child = child.mutate) if mutationRate > 0
      generation << child
    end

    return generation
  end

  # this method returns the mean of one quality through a collection of objects.
  # It's very useful for watching your generations increase in fitness.
  def average(quality = :fitness)
    self.map {|f| f.send(quality)}.inject{ |sum, n| sum + n }.to_f / self.length
  end
end


