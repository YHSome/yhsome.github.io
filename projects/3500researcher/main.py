import csv
import re

# 定义搜索函数，接收三个参数：reader，inset，output_set
def search(reader, inset, output_set):
    out = []
    for row in reader:
        if inset in row[1]:
            out.append(row[0])
    if out != [] and out[0] not in avoid and len(out) < 5 :
        avoid.append(out[0])
        print('-----')
        print(inset , out)


# 定义获取组合函数，接收一个参数：string
# 定义一个函数，用于获取字符串中的组合
def get_combinations(string):
    # 创建一个空列表，用于存储组合
    combinations = []
    # 遍历字符串中的每一个字符
    for i in range(len(string)):
        # 遍历每一个字符后面的每一个字符
        for j in range(i+5, i+1 , -1): #这个“i+？的是用来控制每个元素长度，防止内存爆炸的”
            # 获取两个字符之间的字符串
            substring = string[i:j]
            # 如果字符串的长度大于1，则将字符串添加到组合列表中
            if len(substring) > 1:
                combinations.append(substring)
    # 返回组合列表
    # print(combinations)
    return combinations

def remove_punctuation(text):
    """除去字符串中的标点符号"""
    # 使用正则表达式匹配标点符号，并替换为空字符串
    return re.sub(r'[^\w\s]', '', text)


# 以只读方式打开 'database.csv' 文件
with open('database.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    while True:
        user_input = remove_punctuation(input("请输入要查找的中文，不输入即退出："))
        if user_input == '':
            break
        list_result = get_combinations(user_input)
        output_set = set()
        # 遍历list_result中的每一个元素，调用search函数，传入reader，i，output_set参数
        avoid = []
        for i in list_result:
            f.seek(0)  # 将文件指针重置到开头
            search(reader, i, output_set)