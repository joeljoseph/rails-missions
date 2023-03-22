class Api::FibonaccisController < ApplicationController

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: "parameter missing", status: 400 }, status: 400
  end

  def index
    last_10 = Computation.order('created_at DESC').select(:value, :result, :runtime, :created_at).last(10)
    render json: last_10.as_json(:except => :id)
  end


  def create	
    start = Time.now
    result = fibonacci(fibonacci_params)
    finish = Time.now
    runtime = fibinacci_runtime(start, finish)
    computation = Computation.new( value: fibonacci_params, result: result, runtime: runtime )
    if computation.save
      render json: { value: fibonacci_params, result: result, runtime: runtime }
    else
      render json: { message: "couldn't save the computation to database", status: 'failure'}, status: 200
    end  
  end

  private 

  def fibinacci_runtime(start, finish)
    (finish - start).in_milliseconds
  end

  def fibonacci(n)
  	return n if n <= 1
    fibonacci(n-1) + fibonacci(n-2)
  end


  def fibonacci_params
  	params.require(:n).to_i
  end

end
