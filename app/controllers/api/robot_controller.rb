class Api::RobotController < ApplicationController

	# Api to take commands in below format and return final location
	# {
	#  "commands": [ "PLACE 1,2,EAST ",  "MOVE","MOVE","LEFT","MOVE", "REPORT" ]
	# }

	def orders
		if params[:commands].present? 
			command = params[:commands]
			start = nil
			command.each_with_index{ |value,index| start = index if value.include?("PLACE")}
			commands = start.nil? ? [] : command[start.to_i..(command.length-1)] 
			x,y,facing = [0,0,""]
			commands.each do |cmd|
				if cmd.include?("PLACE ")
					x,y,facing = cmd.gsub("PLACE ","").split(",")
					x = (x.to_i >= 0) ? x.to_i : 0  
					y = (y.to_i >= 0) ? y.to_i : 0
					facing = facing.strip
				elsif cmd.include?("MOVE")
					if facing == "EAST"
						x +=1  if x < 4
					elsif facing == "WEST"
						x-=1   if x > 0
					elsif facing == "SOUTH"
						y -= 1  if y > 0
					elsif facing == "NORTH"
                        y += 1  if y < 4
					end
				elsif cmd.include?("LEFT")
					facing = if facing == "EAST"
								"NORTH"
							elsif facing == "WEST"
								"SOUTH"
							elsif facing == "SOUTH"
								"EAST"
							elsif facing == "NORTH"
								"WEST"
							else
								facing
						    end											
				elsif cmd.include?("RIGHT")
					facing = if facing == "EAST"
								"SOUTH"
							elsif facing == "WEST"
								"NORTH"
							elsif facing == "SOUTH"
								"WEST"
							elsif facing == "NORTH"
								"EAST"
							else
								facing
						    end							
				end
			end
			render json: {location: [x,y,facing]}
		end
	end


	private

	def command
		params.require(:commands)
	end
end
