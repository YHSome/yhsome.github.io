import os

def generate_folder_readme(folder_path):
    for root, dirs, files in os.walk(folder_path):
        # 检查是否存在 index.html 文件
        if 'index.html' in files:
            continue  # 跳过生成 README.md 文件

        # 排除 .git 文件夹
        if '.git' in dirs:
            dirs.remove('.git')

        # 创建 README.md 文件路径
        readme_path = os.path.join(root, 'README.md')

        # 获取当前文件夹的相对路径
        rel_path = os.path.relpath(root, folder_path)

        # 获取父文件夹的路径
        parent_path = os.path.relpath(os.path.dirname(root), folder_path)

        # 创建 README.md 文件
        with open(readme_path, 'w') as readme_file:
            # 添加标题和链接
            readme_file.write('# {}\n\n'.format(os.path.basename(root)))

            # 添加返回链接到父文件夹
            readme_file.write('Go to [parent directory](../{}.md)\n\n'.format(parent_path))

            if dirs:
                readme_file.write('## Subdirectories\n\n')
                for directory in dirs:
                    # 添加子文件夹链接
                    dir_path = os.path.join(rel_path, directory)
                    readme_file.write('- [{}]({})\n'.format(directory, dir_path))

            if files:
                readme_file.write('## Files\n\n')
                for file_name in files:
                    # 添加文件下载链接
                    file_path = os.path.join(rel_path, file_name)
                    readme_file.write('- [{}]({}) \n'.format(file_name, file_path))
                    
folder_path = './'
generate_folder_readme(folder_path)