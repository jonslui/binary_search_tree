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
        current_root = root
        while current_root.left != nil 
            current_root = current_root.left
        end

        return current_root
    end

end


array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

new_tree = Tree.new(array)

new_tree.delete(new_tree.root, 67)

new_tree.insert(new_tree.root, 6)

puts new_tree.root.left.right.left.right.value


