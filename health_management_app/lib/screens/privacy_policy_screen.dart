import 'package:flutter/material.dart';

// =================================================================
// PrivacyPolicyScreen Widget
// 這是應用程式的隱私政策頁面，內容居中呈現且排版精美。
// =================================================================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  // 輔助函式：建立主要的政策標題 (如：一、引言)
  Widget _buildPolicyHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A90E2), // 應用程式的主題藍色
        ),
      ),
    );
  }

  // 輔助函式：建立政策內容的段落
  Widget _buildPolicyParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6, // 增加行高以提升閱讀舒適度
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify, // 長文本使用兩端對齊
      ),
    );
  }

  // 輔助函式：建立政策內容的清單項目
  Widget _buildPolicyListItem(String text) {
    // 移除內容中的粗體標記 (**)
    final cleanText = text.replaceAll('**', '');
    
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7.0),
            child: Icon(Icons.circle, size: 6, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              cleanText, // 使用去除星號後的文本
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String appName = '慢性病健康管理';
    // *** 生效日期已更新為 2025 年 10 月 15 日 ***
    const String effectiveDate = '2025 年 10 月 15 日'; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私權政策',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF5F7FA), // 頁面底色
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center( // 讓內容區塊在寬螢幕上居中
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800), // 限制政策內容的最大寬度
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 政策頂部資訊：應用程式名稱 (置中)
                Center( 
                  child: Text(
                    appName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 4),
                // 生效日期 (置中)
                Center(
                  child: Text(
                    '生效日期：$effectiveDate',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const Divider(height: 30, color: Color(0xFFE0E0E0)),
                
                // --- 政策內容區 ---

                // 1. 引言
                _buildPolicyHeader('一、引言與承諾'),
                _buildPolicyParagraph(
                    '感謝您使用 $appName。我們致力於保護您的個人資料和隱私權。本隱私政策說明了我們如何收集、使用、披露和保護您在使用我們的行動應用程式和服務時提供給我們的信息。'),

                // 2. 我們收集的資訊
                _buildPolicyHeader('二、我們收集的資訊類型'),
                _buildPolicyParagraph('為了向您提供服務，我們可能會收集以下幾種類型的資訊：'),
                // 移除 **
                _buildPolicyListItem('個人身份資訊： 您的姓名、電話號碼、電子郵件地址、年齡和性別。'),
                _buildPolicyListItem('健康資訊： 您的身高、體重、血壓、血糖水平、慢性病史等，這些資訊是為提供健康管理服務所必需的。'),
                _buildPolicyListItem('技術與使用資訊： 設備型號、作業系統版本、IP 地址以及您在應用程式中的活動日誌（例如功能使用頻率）。'),

                // 3. 如何使用您的資訊
                _buildPolicyHeader('三、資訊的使用目的'),
                _buildPolicyParagraph('我們將收集到的資訊用於以下目的：'),
                _buildPolicyListItem('提供、操作和維護我們的服務，包括個人化的健康趨勢分析。'),
                _buildPolicyListItem('與您溝通，回應您的查詢或提供客戶支援。'),
                _buildPolicyListItem('用於研究和分析，以改進我們的服務功能和用戶體驗。'),
                _buildPolicyListItem('在法律要求或得到您明確同意的情況下，發送促銷或通知訊息。'),

                // 4. 資訊的分享與披露
                _buildPolicyHeader('四、資訊的分享與披露'),
                _buildPolicyParagraph('我們僅在以下有限的情況下分享您的個人資料和健康資訊：'),
                _buildPolicyListItem('經過您的同意： 我們會根據您的指示和同意，與您綁定的家人或其他授權方分享您的健康數據。'),
                _buildPolicyListItem('服務供應商： 為了幫助我們運營應用程式，我們可能會與受合約約束的第三方服務供應商分享資訊，但他們僅被允許在為我們提供服務的必要範圍內使用這些資訊。'),
                _buildPolicyListItem('法律要求： 當法律、法規或法院命令要求時，我們必須披露您的資訊。'),

                // 5. 資料安全
                _buildPolicyHeader('五、資料安全與保障'),
                _buildPolicyParagraph(
                    '我們採取多種安全措施來保護您的個人資料免遭未經授權的訪問、更改、披露或破壞。這包括使用加密技術、訪問控制和安全伺服器。然而，沒有任何電子傳輸或儲存方法是絕對安全的。'),

                // 6. 您的權利
                _buildPolicyHeader('六、您的隱私權利'),
                _buildPolicyParagraph(
                    '您有權訪問、更正、更新或要求刪除您的個人資料。您可以通過應用程式內的設定或聯繫我們的支援團隊來行使這些權利。'),

                // 7. 政策變更
                _buildPolicyHeader('七、本政策的變更'),
                _buildPolicyParagraph(
                    '我們可能會不時更新本隱私政策。所有變更將在本頁面上公佈，並在新的生效日期生效。重大變更將通過應用程式通知或電子郵件方式通知您。'),

                // 8. 聯繫我們
                _buildPolicyHeader('八、聯繫我們'),
                _buildPolicyParagraph('如果您對本隱私政策有任何疑問或疑慮，請通過以下方式聯繫我們：'),
                _buildPolicyListItem('電子郵件：support@healthtechsolutions.com'),
                _buildPolicyListItem('服務熱線：(02) 1234-5678'),

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    '感謝您的信任與支持。',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
