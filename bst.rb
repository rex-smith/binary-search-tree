class Node
  def initialize(data=nil, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end
  include Comparable
  attr_accessor :left, :right, :data
end

class Tree
  def initialize(arr)
    @root = build_tree(arr)
  end

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


end


# TESTING
test_array_1 = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
test_tree = Tree.new(test_array_1)

