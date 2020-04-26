class Node
    attr_accessor :value, :right, :left
    def initialize(value)
        @value = value
        @left = nil
        @right = nil
    end
end

class Tree
    attr_accessor :root
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


    def insert(node = self.root, value)
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


    def find(value, node = self.root)
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
            find(value, node)

        # if the value you are searching for is less than the current node
        # continue down the left of the tree
        elsif value < node.value
            node = node.left
            find(value, node)
        end
    end


    def level_order(proc = nil, array2 = [self.root], array = [self.root.value])
        # each time the function runs, the subsiquent level is stored in "array2" while values are pushed to array
        # if the function is called with an array of length 0, that means there are no more levels from the last call on.
        return if array2.length == 0
        tmp = array2
        array2 = []

        # array2 is copied to tmp and then used as a queue, pulling up the node and then pushing the respective
        # node's left/right value to the end of the queue. The first value is then sliced off.
        while tmp.length > 0
            node = tmp[0]

            if node.left != nil
                array2.push(node.left)
                array.push(node.left.value)
            end
            
            if node.right != nil
                array2.push(node.right)
                array.push(node.right.value)
            end

            tmp = tmp.slice(1..-1)
        end

        level_order(proc, array2, array)

        if proc != nil
            array2.each do |value|
                proc.call(value)
            end
        else
            return array
        end
    end


    # left, root, right
    # if no proc, node.value is added to array and then returned
    # else the function runs a user made proc on each value
    def inorder(node=self.root, proc=nil, array=[])
        if node
            inorder(node.left, proc, array)

            if proc != nil
                proc.call(node.value)
            else
                array << node.value
            end
    
            inorder(node.right, proc, array)
        end
        array
    end

    # root, left, right
    # if no proc, node.value is added to array and then returned
    # else the function runs a user made proc on each value
    def preorder(node=self.root, proc=nil, array=[])
        if node
            if proc != nil
                proc.call(node.value)
            else
                array << node.value
            end

            preorder(node.left, proc, array)

            preorder(node.right, proc, array)
        end
        array
    end

    # left, right, root
    # if no proc, node.value is added to array and then returned
    # else the function runs a user made proc on each value
    def postorder(node = self.root, proc=nil, array=[])
        if node
            postorder(node.left, proc, array)

            postorder(node.right, proc, array)

            if proc != nil
                proc.call(node.value)
            else
                array << node.value
            end
        end
        array
    end

    # function moves across each level and level_counter increases each time the function is called
    # aka each time the function finishes a level. When the function reachs the searched value it returns the level.
    # level_counter starts at 1 to account for the root node
    def test_depth(node, array = [self.root], level_counter = 1)
        if array.length == 0
            return "The tree is #{level_counter - 1} levels deep"
        end

        tmp = array
        array = []

        while tmp.length > 0
            current_node = tmp[0]
            if current_node == node
                puts "Node located on level #{level_counter}"
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
        depth(node, array, level_counter)
    end

    # takes a node and returns the number of levels below and including the node
    def depth(current_node = self.root, left_depth = 0, right_depth = 0)
        return 0 if current_node == nil
        left_depth = depth(current_node.left)
        right_depth = depth(current_node.right)

        if left_depth > right_depth
           return left_depth + 1
        else
           return right_depth + 1
        end
    end

    def balanced?
        left_side_depth = depth(self.root.left)
        right_side_depth = depth(self.root.right)

        if left_side_depth - 1 > right_side_depth
            return "The tree is unbalanced, the left side is #{left_side_depth - right_side_depth} levels deeper."
        elsif right_side_depth - 1 > left_side_depth
            return "The tree is unbalanced, the right side is #{right_side_depth - left_side_depth} levels deeper."
        else
            return "The tree is balanced."
        end
    end

    def rebalance!
        array = self.level_order
        array.sort!.uniq!
        # puts array
        self.root = build_tree(array)
    end
end


# Driver Script
array = Array.new(15) {rand(1..100)}

new_tree = Tree.new(array)

puts new_tree.balanced?

print new_tree.level_order
puts
print new_tree.preorder
puts
print new_tree.postorder
puts
print new_tree.inorder
puts

unbalance_tree = Array.new(15) {rand(1..100)}

unbalance_tree.each { |random_value| new_tree.insert(random_value) }

puts new_tree.balanced?

new_tree.rebalance!

puts new_tree.balanced?

print new_tree.level_order
puts
print new_tree.preorder
puts
print new_tree.postorder
puts
print new_tree.inorder
puts

