document.addEventListener("DOMContentLoaded", function() {  
    var button = document.getElementById("highlight");  
    var colors = ["red", "orange", "yellow", "green", "blue", "indigo", "violet"];  
    var index = 0;  

    setInterval(function() {  
        button.style.backgroundColor = colors[index];  
        index = (index + 1) % colors.length;  // 循环到第一个颜色时重新开始  
    }, 100);  // 每秒改变一次颜色  
});  

//搜索的逻辑
let data1 = '';
let csvData = []; // 用于存储CSV数据的数组

async function fetchData() {
    const resultsDiv = document.getElementById('results');
    resultsDiv.innerHTML = '数据正在加载...'; // 显示加载提示

    try {
        const response = await fetch('dataFile.json');
        const data = await response.json();
        console.log('数据已加载', data);
        data1 = data.data.split('#####'); // 可能需要更新此处的逻辑
        console.log('数据分割', data1);

        // 遍历每一行，填充 csvData 数组
        for (let row of data1) {
            if (row.includes('#####')) {
                csvData.push(row.split('#####'));
            } else {
                csvData.push([row]);
            }
        }

        console.log(csvData); // 输出处理后的 csvData 数组
        resultsDiv.innerHTML = '请输入关键词以搜索...'; // 清空之前的加载提示
    } catch (error) {
        console.error('发生错误：', error);
        resultsDiv.innerHTML = '加载数据失败，请稍后再试。'; // 显示错误提示
    }
}

fetchData();

// 搜索CSV并显示结果  
function searchCSV() {  
    const searchTerm = document.getElementById('search-input').value.toLowerCase();  
    const resultsDiv = document.getElementById('results');  
    resultsDiv.innerHTML = '请输入关键词以搜索...'; // 清空之前的结果  

    if (searchTerm.trim() === '') return; // 如果搜索词为空，则退出函数  

    // 获取要删除的元素的选择器，这里假设要删除类名为"myDivClass"的元素  
    var selector = "div.results";  
    // 使用querySelectorAll方法获取所有匹配的元素  
    var elements = document.querySelectorAll(selector);  
    // 循环遍历匹配的元素并删除它们  
    for (var i = 0; i < elements.length; i++) {  
        elements[i].parentNode.removeChild(elements[i]);  
    }

    let matchCount = 0; // 用于跟踪匹配的数量  
    csvData.forEach(row => {  
        const rowAsText = row.join(',').toLowerCase(); // 将行转换为文本并转换为小写以便比较  
        if (rowAsText.includes(searchTerm)) { // 如果行包含搜索词  
            matchCount++; // 增加匹配计数器  
            if (matchCount >= 2) { // 如果匹配数量大于或等于2，则不显示结果并提示用户更换关键词  
                resultsDiv.innerHTML = '多个结果，请换个关键词搜索。';  
                return; // 结束循环，不再检查其他行  
            } else if (matchCount === 1) { // 如果匹配数量等于1，直接显示结果，无需额外提示用户  
                // 将多行字符串分割成数组  
                var lines = rowAsText.split("\n");  
                // 创建用于存储<div>元素的数组  
                var divs = [];  
                // 循环遍历每一行，并为每一行创建一个<div>元素  
                lines.forEach(function(line, index) {  
                    var div = document.createElement("div");  
                    div.textContent = line;  
                    // 为每个<div>元素设置一个类名  
                    div.className = "results"; // 可以根据需要更改类名  
                    divs.push(div);  
                });  
                // 将创建的<div>元素添加到DOM中，这里以body元素为例  
                document.body.appendChild(divs[0]);  
                for (var i = 1; i < divs.length; i++) {  
                    document.body.appendChild(divs[i]);  
                }
                resultsDiv.innerHTML = '搜索到一个结果。';  
            } else { // 如果匹配数量为0，不提示用户更换关键词，直接结束循环，不再检查其他行  
                return; // 结束循环，不再检查其他行  
            }  
        }  
    });  
    if (matchCount === 0) { // 如果匹配数量为0，提示用户没有找到结果并换个关键词搜索  
        resultsDiv.innerHTML = '没有找到结果，请换个关键词搜索。';  
    } else if (matchCount === 1) { // 如果匹配数量等于1，显示结果，但不给出特定提示（已在上面处理）  
        // Do nothing, result already displayed above.  
    } else { // 如果匹配数量大于或等于2，给出特定提示（已在上面处理）  
        // 获取要删除的元素的选择器，这里假设要删除类名为"myDivClass"的元素  
        var selector = "div.results";  
        // 使用querySelectorAll方法获取所有匹配的元素  
        var elements = document.querySelectorAll(selector);  
        // 循环遍历匹配的元素并删除它们  
        for (var i = 0; i < elements.length; i++) {  
            elements[i].parentNode.removeChild(elements[i]);  
        }
    }  
}