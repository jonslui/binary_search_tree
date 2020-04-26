class Node

    attr_accessor :value, :right, :left


    def initialize(value)
        @value = value
        @left = nil
        @right = nil
    end

end


class Tree

    attr_reader :root

    def initialize(array)
        array.sort!.uniq!
        @root = build_tree(array)
    end


    def build_tree(arr)
        # catch exceptions
        return unless arr[0]
        return Node.new(arr[0]) if arr.length <= 1

        middle = arr.length/2

        root = Node.new(arr[middle])
        root.left = build_tree(arr[0...middle])
        root.right = build_tree(arr[middle+1..-1])
        root

    end


    def insert(node, value)
        # if new value > current_node call insert with node.right, else call with node.left
        # continue until node.right/left == nil, or until value is the same as new value
        if value > node.value
            if node.right == nil
                node.right = Node.new(value)
                return
            end
            insert(node.right, value)

        elsif value < node.value
            if node.left ==  nil
                node.left = Node.new(value)
                return
            end
            insert(node.left, value)
        end
        return
    end


    def delete(root, value)
        # base case
        if root == nil
            return root 

        # if value seached for is less than root
        # then value lies in the left side of tree
        elsif value < root.value
            root.left = delete(root.left, value)

        # else if value is greater than root,
        # value lies on the right side
        elsif value > root.value
            root.right = delete(root.right, value)

        #if key is the same as the root's, 
        # then this is the node to be deleted
        else

            # case 1: no child or one child
            if root.left == nil
                tmp = root.right
                root = nil
                return tmp

            elsif root.right == nil
                tmp = root.left
                root = nil
                return tmp


            # case 2: two children: 
            # get smallest in right subtree
            else
                tmp = find_min(root.right)
                # copy lowests value to tmp
                root.value = tmp.value
                # delete lowest
                root.right = delete(root.right, tmp.value)
            end
        end
        return root 
    end


    def find_min(root)
        # continue down left side of tree until current_root.left == nil
        # in this case current_node is the lowest value
        current_node = root
        while current_node.left != nil 
            current_node = current_node.left
        end

        return current_node
    end


    def find(node, value)
        # if you reach the bottom of the tree (==nil) then number is not in tree
        if node == nil
            puts "Not Found!"
            return

        # return node if it is present in table
        elsif node.value == value
            return node

        # if the value of the current node is less than the value you are searching for,
        # continue to the right
        elsif value > node.value
            node = node.right
            find(node, value)

        # if the value you are searching for is less than the current node
        # continue down the left of the tree
        elsif value < node.value
            node = node.left
            find(node, value)
        end
    end


    def level_order(proc = nil, array=[self.root])
        # each time the function runs, the subsiquent level is stored in "array"
        # so if the function is called with an array of length 0, that means there are no more levels from the last call on.
        return if array.length == 0
        tmp = array
        array = []

        # array is copied to tmp and then used as a queue, pulling up the node and then pushing the respective
        # node's left/right value to the end of the queue. The first value is then sliced off.
        while tmp.length > 0
            node = tmp[0]

            if node.left != nil
                array.push(node.left)
            end
            
            if node.right != nil
                array.push(node.right)
            end

            tmp = tmp.slice(1..-1)
        end

        level_order(proc, array)

        if proc != nil
            array.each do |value|
                proc.call(value)
            end
        else

            # fix here

            array.each do |node|
                node.value
            end
        end
    end


    # left, root, right
    def inorder(node, proc=nil)
        if node
            inorder(node.left, proc)

            if proc != nil
                proc.call(node.value)
            else
                print "#{node.value} "
            end
    
            inorder(node.right, proc)
        end
    end

    # root, left, right
    def preorder(node, proc=nil)
        if node
            if proc != nil
                proc.call(node.value)
            else
                print "#{node.value} "
            end

            preorder(node.left, proc)

            preorder(node.right, proc)
        end
    end

    # left, right, root
    def postorder(node, proc=nil)
        if node
            postorder(node.left, proc)

            postorder(node.right, proc)

            if proc != nil
                proc.call(node.value)
            else
                print "#{node.value} "
            end
        end
    end

    # function moves across each level and level_counter increases each time the function is called
    # aka each time the function finishes a level. When the function reachs the searched value it returns the level.
    def depth(node, current_node = self.root, array = [self.root], level_counter = 1)
        return if array.length == 0

        tmp = array
        array = []

        while tmp.length > 0
            current_node = tmp[0]
            if current_node == node
                return "Node located on level #{level_counter}"
            end

            if current_node.left != nil
                array.push(current_node.left)
            end
            
            if current_node.right != nil
                array.push(current_node.right)
            end

            tmp = tmp.slice(1..-1)
        end

        level_counter += 1
        depth(node, current_node, array, level_counter)
    end



end


array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

new_tree = Tree.new(array)


new_tree.delete(new_tree.root, 67)


# new_tree.insert(new_tree.root, 320)
# new_tree.insert(new_tree.root, 6400)


# puts new_tree.find(new_tree.root, 4)
# puts new_tree.find(new_tree.root, 6)
puts new_tree.find(new_tree.root, 67)


# puts new_tree.level_order


# level_order_proc = Proc.new do |val| 
#     if val.value == 6345
#         puts "true"
#     end
# end

# new_tree.level_order(level_order_proc)



# inorder_proc = Proc.new do |val|
#     print "#{val} "
# end 

# new_tree.inorder(new_tree.root, inorder_proc)


# new_tree.inorder(new_tree.root)
# puts

# new_tree.preorder(new_tree.root)
# puts

# new_tree.postorder(new_tree.root)
# puts


# puts new_tree.find(new_tree.root, 8)

puts new_tree.depth(new_tree.find(new_tree.root, 4))


# fix the functions that are not returning