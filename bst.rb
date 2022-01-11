class Node
  def initialize(data=nil, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end
  include Comparable
  attr_accessor :left, :right, :data

  def <=>(other)
    value = other.class == Node ? other.data : other
    data <=> value
  end

  def inspect
    @data
  end
end

class Tree
  def initialize(arr)
    @root = build_tree(arr)
  end

  attr_reader :root

  def build_tree(arr)
    # Sort and remove duplicates
    prep_arr = arr.sort.uniq
    p prep_arr
    # Build the tree
    sortedArrayToBST(prep_arr, 0, prep_arr.length-1)
  end
  
  def sortedArrayToBST(arr, start, finish)
    return nil if (start>finish)
    mid = ((start + finish) / 2)
    root = Node.new(arr[mid])
    root.left = sortedArrayToBST(arr, start, mid-1)
    root.right = sortedArrayToBST(arr, mid+1, finish)
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node=root)
    return nil if value == node.data
    
    if value < node.data
      if node.left == nil
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    else
      if node.right == nil
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    end
  end

  def delete(value, node=root)
    # Return nil if you can't find the node to be deleted
    return node if node == nil

    # Search for the correct node
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # This is the key to be deleted
      # Handle the 1 child or no child scenarios
      if node.left.nil?
        temporary = node.right
        node = nil
        return temporary
      elsif node.right.nil?
        temporary = node.left
        node = nil
        return temporary
      end

      # We must have two children 
    
      temporary = minValueNode(node.right)
      node.data = temporary.data 
      node.right = delete(temporary.data, node.right)
    end
    return node
  end

  def minValueNode(node)
    current = node
    until current.left.nil?
      current = current.left
    end
    return current
  end

  def find(value, node=root)
    if node == nil
      puts "No match found"
      return
    end

    if node.data == value
      # puts "Match found: #{node}"
      return node
    elsif value < node.data
      find(value, node.left)
    elsif value > node.data
      find(value, node.right)
    end

  end

  def level_order_rec(queue=[@root], arr=[], &block)
    curr = queue.shift
    
    # Stopping function for recursion
    return if curr.nil?

    queue << curr.left if curr.left != nil 
    queue << curr.right if curr.right != nil
    # Yield to block or add the data for current node to the array of values
    # in case no block
    block_given? ? block.call(curr.data) : arr << curr.data
    level_order_rec(queue, arr, &block)
    arr unless block_given?
  end

  def inOrder(node=@root, arr=[], &block)
    return if node.nil?
    inOrder(node.left, arr, &block)
    block_given? ? block.call(node.data) : arr << node.data
    inOrder(node.right, arr, &block)
    arr unless block_given?
  end

  def preOrder(node=@root, arr=[], &block)
    return if node.nil?
    block_given? ? block.call(node.data) : arr << node.data
    preOrder(node.left, arr, &block)
    preOrder(node.right, arr, &block)
    arr unless block_given?
  end

  def postOrder(node=@root, arr=[], &block)
    return if node.nil?
    postOrder(node.left, arr, &block)
    postOrder(node.right, arr, &block)
    block_given? ? block.call(node.data) : arr << node.data
    arr unless block_given?
  end

  def height(node=@root)
    return 0 if node.nil?
    if node.left == nil && node.right == nil
      return 0
    end
    left_height = height(node.left)
    right_height = height(node.right)
    max_height = [left_height, right_height].max
    max_height += 1
    return max_height
  end

  def depth(node)
    current_node = @root
    # Counter for each level searched
    counter = 0
    while node.data != current_node.data
      if node < current_node
        counter += 1
        current_node = current_node.left
      else
        counter +=1
        current_node = current_node.right
      end
    end
    counter
  end

  def balanced?(node=@root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)

    difference = (left_height - right_height).abs

    left_bal = balanced?(node.left)
    right_bal = balanced?(node.right)

    return true if (difference <= 1) && left_bal && right_bal
    false
  end

  def rebalance
    @root = build_tree(level_order_rec)
  end

end


# TESTING
# test_array_1 = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# test_tree = Tree.new(test_array_1)

# # test_tree.pretty_print
# test_tree.insert(46)
# test_tree.insert(2)
# test_tree.insert(123412)
# test_tree.insert(10002)
# test_tree.insert(1299)
# test_tree.pretty_print
# p test_tree.balanced?

# # test_tree.delete(23)
# test_tree.pretty_print
# test_tree.delete(4)
# test_tree.pretty_print
# test_tree.delete(46)
# test_tree.pretty_print

# test_tree.find(23)
# test_tree.find(18)

# p test_tree.root.left < test_tree.root.right

# # Level Order Tests
# p test_tree.level_order_rec
# test_tree.level_order_rec {|i| print ".#{i}."}
# puts

# Depth Order Tests
# puts "In Order"
# p test_tree.inOrder
# test_tree.inOrder {|i| print "-#{i}-"}
# puts
# puts "Pre Order"
# p test_tree.preOrder
# test_tree.preOrder {|i| print "-#{i}-"}
# puts
# puts "Post Order"
# p test_tree.postOrder
# test_tree.postOrder {|i| print "-#{i}-"}

# Height Test
# p test_tree.height(test_tree.find(8))

# Depth Test
# p test_tree.depth(test_tree.find(46))
# p test_tree.depth(test_tree.find(99))





# Final Tests
final_test = Tree.new((Array.new(15) {rand(1..100)}))
final_test.pretty_print

# Check if balanced
puts "Balanced: #{final_test.balanced?}"

# Print contents in the various orders
puts "Level Order: "
p final_test.level_order_rec
puts "In Order: "
p final_test.inOrder
puts "Pre Order: "
p final_test.preOrder
puts "Post Order: "
p final_test.postOrder

# Inserted numbers above 100 to unbalance
final_test.insert(rand(100..1000))
final_test.insert(rand(100..1000))
final_test.insert(rand(100..1000))
final_test.pretty_print

# Check if balanced again
puts "Balanced: #{final_test.balanced?}"

# Rebalance
final_test.rebalance
final_test.pretty_print

# Check if balanced again
puts "Balanced: #{final_test.balanced?}"

# Print contents in the various orders
puts "Level Order: "
p final_test.level_order_rec
puts "In Order: "
p final_test.inOrder
puts "Pre Order: "
p final_test.preOrder
puts "Post Order: "
p final_test.postOrder