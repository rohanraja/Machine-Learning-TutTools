class HomeController < ApplicationController


  def index
  end

  def matlabDir
    
    return "lib/matlabFiles"

  end

  def algoDir(algo = 0)

    algos = ["logisticRegression", "neuralNetwork"]

    matDir = matlabDir 

    return matDir + "/" + algos[algo]

  end

  def dataDir(algo = 0)
    return algoDir(algo)
  end

  def gradDesc


  	x = ActiveSupport::JSON.decode(params['q'])


  	samples = x['rawTrainingData']['samples']

  	f = open("#{dataDir}/data.csv", "w")

  	line = ""

  	samples.each do |s|
  		inp = s['inputVector']
  		line = line + inp[0].to_s + "," + inp[1].to_s + "," + s['outputVal'].to_s + "\n"

  	end

  	f.write(line)

  	f.close


  	out2 = `/usr/local/octave/3.8.0/bin/octave -q '#{algoDir}/wrapper.m'`

  	finalTheta = ActiveSupport::JSON.decode(out2)

  	out = {:finalTheta => finalTheta}

  	render :json => out.to_json
  end


  def heatMapPoints
  	require 'csv'


  	x = ActiveSupport::JSON.decode(params['q'])
  	theta = x["hypoFunctions"][0]["theta"]
  	gridData = ActiveSupport::JSON.decode(params['gridData'])

  	CSV.open("#{algoDir}/heatPoints.csv", "w") do |csv|
  		csv << theta
  		csv << gridData
  	end

  	out2 = `/usr/local/octave/3.8.0/bin/octave -q '#{algoDir}/heatmap.m'`

  	f = open("#{algoDir}/heatPoints.csv")

  	data = f.read

  	
  	the_array = CSV.parse(data)


  	f.close

  	render :json => the_array.to_json

  end

end
