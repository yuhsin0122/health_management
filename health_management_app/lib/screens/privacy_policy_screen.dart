import 'package:flutter/material.dart';

// =================================================================
// 隱私政策頁面 (已修改為更正式的排版)
// =================================================================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // 輔助方法：建構正式分隔線 (與服務條款頁面一致)
  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: Colors.black12, // 淺灰色分隔線
      ),
    );
  }

  // Helper function for building consistent content sections (已優化樣式)
  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 使用更醒目、專業的標題樣式
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700, // 更粗的字體
            color: Colors.black, // 保持黑色，強調正式性
          ),
        ),
        const SizedBox(height: 10), // 增加間距
        Text(
          content,
          // 內文使用 justify 對齊，增加行高以提高可讀性
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 15.5,
            height: 1.7, // 增加行高
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 獲取當前日期，用於政策生效日
    final now = DateTime.now();
    final effectiveDate = '${now.year} 年 ${now.month} 月 ${now.day} 日';

    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私權政策', 
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // 增加頁面邊緣填充，更像正式文件
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 主標題 (已修改為更粗黑的樣式)
            const Text(
              '隱私權政策聲明',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              '生效日期：$effectiveDate',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            
            // 簡短介紹（新增，增加正式文件感）
            const SizedBox(height: 25),
            const Text(
              '本政策旨在向您說明我們如何處理您的個人資料。請仔細閱讀，您對本應用程式的使用即表示您同意本政策條款。',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            
            const SizedBox(height: 30),

            // 1. 政策適用範圍
            _buildSection(
              title: '1. 政策適用範圍',
              content: '本隱私權政策適用於[應用程式名稱]（以下簡稱「本應用程式」或「我們」）提供的所有產品與服務。本政策旨在說明我們如何收集、使用、處理和保護您在使用我們的服務時所提供的個人資訊。若您不同意本政策條款，請立即停止使用本應用程式。',
            ),
            
            _buildSeparator(),
            // 2. 資訊之收集
            _buildSection(
              title: '2. 資訊之收集',
              content: '我們主要收集以下兩類資訊：\n\n'
                  '2.1 **您直接提供的資訊：** 包括但不限於註冊或登入時的電子郵件地址、用戶名稱、密碼（加密後）、以及為使用特定功能而自願提供的個人資料。\n\n'
                  '2.2 **自動收集的資訊：** 當您存取和使用本應用程式時，我們會自動收集某些資訊，例如您的設備型號、操作系統版本、IP 地址、使用時間、應用程式活動日誌、以及服務錯誤報告。此類資訊用於服務分析與優化。',
            ),
            
            _buildSeparator(),
            // 3. 資訊使用目的
            _buildSection(
              title: '3. 資訊使用目的',
              content: '我們將收集到的資訊用於以下目的：\n\n'
                  '3.1 **提供和維護服務：** 確保應用程式功能的正常運作，執行必要的更新與維護。\n'
                  '3.2 **服務優化與開發：** 分析用戶行為，以改善現有功能，並開發新的產品或服務。\n'
                  '3.3 **安全性與合規性：** 偵測、預防和解決技術問題或欺詐行為，並遵守所有適用的法律、法規及要求。',
            ),
            
            _buildSeparator(),
            // 4. 資訊的共享與揭露
            _buildSection(
              title: '4. 資訊的共享與揭露',
              content: '我們承諾不會將您的個人資訊出售、租賃或交換給任何非關聯的第三方。在以下例外情況下，我們可能會共享或揭露您的資訊：\n\n'
                  '4.1 **徵得您的同意：** 在取得您明確授權的情況下。\n'
                  '4.2 **合作夥伴或服務供應商：** 基於提供服務的必要性（例如雲端儲存、數據分析），我們可能與簽訂嚴格保密協議的第三方服務供應商共享資訊。\n'
                  '4.3 **法律要求：** 當我們收到法院傳票、法律命令或政府機構的合法要求時，為遵守法律程序或保護我們的權利和財產。',
            ),
            
            _buildSeparator(),
            // 5. 資料安全措施
            _buildSection(
              title: '5. 資料安全措施',
              content: '我們採取合理的、業界標準的安全措施來保護您的個人資料，防止未經授權的存取、變更、揭露或銷毀。這些措施包括使用 SSL/TLS 加密技術進行數據傳輸，以及在儲存資料時進行加密處理。儘管如此，互聯網上的數據傳輸或電子儲存方式無法保證 \$100% 絕對安全。',
            ),
            
            _buildSeparator(),
            // 6. 政策修訂與聯繫方式
            _buildSection(
              title: '6. 政策修訂與聯繫方式',
              content: '6.1 **政策變更：** 我們保留隨時修訂本隱私權政策的權利。任何變更將透過在應用程式內發布新政策或發送電子郵件通知的方式生效。建議您定期審閱本政策。\n\n'
                  '6.2 **聯繫我們：** 如果您對本隱私權政策有任何疑問或疑慮，請透過以下方式與我們聯繫：\n'
                  '   電子郵件：[您的聯絡信箱]\n'
                  '   通訊地址：[您的公司/開發者地址]',
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              '感謝您閱讀我們的隱私權政策。',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
