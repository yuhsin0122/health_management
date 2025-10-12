import 'package:flutter/material.dart';

// =================================================================
// 服務條款及使用者協議頁面 (已修改為更正式的排版)
// =================================================================
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  // 輔助方法：建構每個條款區塊
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
        const SizedBox(height: 10),
        // 內文使用 justify 對齊，增加行高以提高可讀性
        Text(
          content,
          textAlign: TextAlign.justify, // 增加正式感
          style: const TextStyle(
            fontSize: 15.5,
            height: 1.7, // 增加行高
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // 輔助方法：建構正式分隔線
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服務條款及使用者協議', 
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
            // 主標題
            const Text(
              '服務條款',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black), // 更粗黑的主標題
            ),
            const SizedBox(height: 10),
            // 更新日期
            Text(
              '最後更新：${DateTime.now().year} 年 ${DateTime.now().month} 月 ${DateTime.now().day} 日',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            
            // 簡短介紹（新增，增加正式文件感）
            const SizedBox(height: 25),
            const Text(
              '歡迎使用我們的服務。請仔細閱讀以下條款，您對本應用程式的使用即表示您接受並同意遵守本協議的所有條款與條件。',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            
            // 條款主要內容
            const SizedBox(height: 30),

            // 1. 接受協議
            _buildSection(
              title: '1. 接受協議',
              content: '使用本應用程式即表示您同意本服務條款。如果您不同意本協議的任何部分，請不要使用本應用程式。',
            ),

            _buildSeparator(),
            // 2. 帳號註冊與安全
            _buildSection(
              title: '2. 帳號註冊與安全',
              content: '用戶必須提供真實、準確、完整的註冊資訊。您對您的帳號安全負全部責任，包括所有在您的帳號下發生的活動。若發現任何未經授權使用您帳號的情況，您應立即通知我們。',
            ),
            
            _buildSeparator(),
            // 3. 用戶行為規範
            _buildSection(
              title: '3. 用戶行為規範',
              content: '您同意在使用本應用程式時，遵守所有適用的法律法規，並不得從事以下行為：上傳或發布非法、有害、威脅、辱罵、騷擾、誹謗、淫穢或侵犯隱私的內容；傳輸病毒或任何惡意程式碼；試圖未經授權存取本服務或其相關系統。',
            ),

            _buildSeparator(),
            // 4. 數據所有權與隱私
            _buildSection(
              title: '4. 數據所有權與隱私',
              content: '您上傳的所有醫療及個人數據歸您所有。我們將依據我們的《隱私政策》使用和保護您的數據。為提供服務，您授予我們在全球範圍內使用、複製和分發您的非個人身份數據的權限。',
            ),

            _buildSeparator(),
            // 5. 服務終止與取消
            _buildSection(
              title: '5. 服務終止與取消',
              content: '我們保留隨時以任何理由、無需事先通知的情況下，暫停或終止您的帳號和服務存取權利的權利，包括但不限於違反本條款。您可隨時透過應用程式介面或聯絡客服取消您的帳號。',
            ),

            _buildSeparator(),
            // 6. 免責聲明與責任限制
            _buildSection(
              title: '6. 免責聲明與責任限制',
              content: '本服務按「原樣」和「現有」基礎提供。我們不對服務的適用性、可靠性或準確性作出任何保證。在適用法律允許的最大範圍內，我們不對任何間接、偶然或懲罰性損害承擔責任。',
            ),
            
            _buildSeparator(),
            // 7. 條款修訂
            _buildSection(
              title: '7. 條款修訂',
              content: '我們保留隨時修改或替換本條款的權利。如果修訂是實質性的，我們將提前至少 30 天通知。在修訂生效後繼續使用本應用程式即視為您接受修訂後的條款。',
            ),

            _buildSeparator(),
            // 8. 適用法律
            _buildSection(
              title: '8. 適用法律',
              content: '本服務條款受中華民國（台灣）法律管轄，並據其解釋。任何因本協議引起的或與之相關的爭議，應由台灣台北地方法院管轄。',
            ),

            const SizedBox(height: 30),
            
            const Text(
              '感謝您閱讀我們的服務條款。',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
