class LawyersController < ApplicationController
	require 'open-uri'
	# => GET http://localhost:3000/lawyer_experience/:mail
	# => Params: acepta una cadena de texto que tenga el formato de un correo electronico.
	#
	# Obtiene los datos en JSON desde la api https://api.workon.law/technical_challenge/get_lawyers
	# para luego convertirlos en un Hash con la finalidad de iterarlos y buscar el mail especificado
	def getExperience
		if (params[:mail].include? "@") && (params[:format] != nil)
			fullData = JSON.load(URI.open("https://api.workon.law/technical_challenge/get_lawyers"))["candidates"]
			@days = 0
			fullData.each do |value|
				if value["email"].eql? (params[:mail]+"."+params[:format])
					@lawyer = Lawyer.new(email: value["email"], name: value["name"], surname: value["surname"])
					value["works"].each do |data|
						if @start == nil && @end == nil
							if data["end"] == nil
								@days += (Date.today - data["start"].to_date).to_i + 1
								@start = data["start"].to_date
								@end = Date.today
							else
								@days += (data["end"].to_date - data["start"].to_date).to_i + 1
								@start = data["start"].to_date
								@end = data["end"].to_date
							end
						else
							if data["end"] == nil
								unless data["start"].to_date <= @end && @start <= Data.today
									@days += (Date.today - data["start"].to_date).to_i + 1
									@start = data["start"].to_date
									@end = Date.today
								end
							else
								unless data["start"].to_date <= @end && @start <= data["end"].to_date
									@days += (data["end"].to_date - data["start"].to_date).to_i + 1
									@start = data["start"].to_date
									@end = data["end"].to_date
								end
							end
						end
					end
					break
				end
			end
			if @lawyer
				@send = {"email"=>@lawyer.email,"work_experience_years"=>(@days.to_f/365).round(2)}
				render :json => @send
			else
				notFound
			end
		else
			invalidEmail
		end
	end

	private
		def invalidEmail
			@send = {"email"=>"Email invalido","work_experience_years"=>nil}
			render :json => @send
		end
		def notFound
			@send = {"email"=>"Email no encontrado","work_experience_years"=>nil}
			render :json => @send
		end
end
