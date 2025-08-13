namespace :assets do
  desc "Optimize SVGs in app/assets/images with svgo if available"
  task :optimize_svgs do
    svgo = `command -v svgo`.strip
    if svgo.empty?
      puts "svgo not found. Install with: npm i -g svgo"
      next
    end
    Dir.glob(Rails.root.join('app/assets/images/**/*.svg')).each do |svg|
      system("svgo --multipass \"#{svg}\"")
    end
    puts "SVG optimization complete."
  end
end

