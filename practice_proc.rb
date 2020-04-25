proc = Proc.new {|input| puts input }

array = [0,1,2,3,4,5,6,7,8,9]
def test(array, proc=nil)

    if proc != nil
        array.each do |value|
            proc.call(value)
        end
    else
        puts "no proc"
    end

end



test(array, proc)
test(array)