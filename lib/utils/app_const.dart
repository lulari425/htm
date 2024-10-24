// Gemini API Key
const apiKey = 'your api key';

// Gemini Model
const String geminiModelPro = "gemini-1.5-pro-latest";
const String geminiModelFlash = "gemini-1.5-fl`ash-latest";
// const String imagen3 = "imagen-3.0-generate-001";

const String guidlines = """
생성형 AI 금지된 사용 정책 / Prohibited Uses of Generative AI

1. 위험하거나 불법이거나 악의적인 활동을 수행 또는 조장 / Engaging in or promoting harmful, illegal, or malicious activities, including:
    - 불법적인 행위나 법률 위반을 조장 또는 용이하게 하는 행위 / Facilitating or promoting illegal activities or violations of the law.
    - 아동 성적 학대 또는 착취와 관련된 콘텐츠를 조장 또는 생성 / Creating or promoting content related to child sexual abuse or exploitation.
    - 불법 약품, 상품 또는 서비스의 판매를 조장/촉진 또는 이를 합성하거나 접근하는 방법 안내 / Promoting or facilitating the sale of illegal drugs, goods, or services, or providing instructions on how to synthesize or access them.
    - 모든 유형의 범죄를 조장 또는 종용 / Encouraging or inciting any type of criminal activity.
    - 폭력적인 극단주의 또는 테러 관련 콘텐츠를 조장 또는 생성 / Creating or promoting content related to violent extremism or terrorism.

2. 서비스를 악용, 손상, 방해 또는 중단 / Misusing, damaging, disrupting, or interrupting the service, including:
    - 스팸의 생성/배포를 조장 또는 촉진 / Promoting or facilitating the creation/distribution of spam.
    - 기만 행위, 허위 행위, 사기, 피싱 또는 멀웨어 관련 콘텐츠를 생성 / Creating content related to deception, fraud, phishing, or malware.
    - 보안 필터를 무효화 또는 회피하거나 의도적으로 Google 정책에 위배되는 방식으로 모델을 작동하려는 시도 / Attempting to bypass or disable security filters or intentionally operating the model in a manner that violates Google policies.

3. 개인 또는 집단에 해를 끼치거나 해를 끼치도록 조장하는 콘텐츠를 생성 / Creating content that harms or encourages harm to individuals or groups, including:
    - 증오심을 조장하거나 부추기는 콘텐츠를 생성 / Creating content that promotes or incites hatred.
    - 타인을 위협하거나, 학대하거나, 모욕하기 위한 괴롭힘이나 폭력을 조장 / Encouraging harassment or violence to threaten, abuse, or insult others.
    - 폭력을 조장, 선전 또는 선동하는 콘텐츠를 생성 / Creating content that promotes, glorifies, or incites violence.
    - 자해를 조장, 용이하게 하거나 종용하는 콘텐츠를 생성 / Creating content that encourages, facilitates, or incites self-harm.
    - 배포 또는 기타 위해를 가할 목적으로 개인 식별 정보를 생성 / Creating personally identifiable information for distribution or other harmful purposes.
    - 동의 없이 사용자를 추적 또는 모니터링 / Tracking or monitoring users without consent.
    - 사람에게 불공정하거나 부정적인 영향을 미칠 수 있는 콘텐츠를 생성 / Creating content that could unfairly or negatively impact individuals, especially in relation to sensitive or protected characteristics.

4. 오인, 허위 진술, 오해의 소지가 있는 콘텐츠를 생성 및 배포 / Creating and distributing misleading, false, or deceptive content, including.
    - 속일 목적으로 사람이 생성한 콘텐츠라고 주장하거나 생성된 콘텐츠를 원작이라고 표시하여 생성된 콘텐츠의 출처를 허위로 진술 / Falsely claiming that generated content is human-created or misrepresenting the origin of generated content as original.
    - 속일 목적으로 명시적인 공개 없이 다른 사람을 (생사 여부 관계없이) 가장하는 콘텐츠를 생성 / Creating content that impersonates others (living or deceased) without explicit disclosure for deceptive purposes.
    - 특히 민감한 영역(예: 건강, 금융, 정부 서비스, 법률)에 관한 전문성 또는 역량에 대해 혼동을 야기하는 주장 / Making claims that cause confusion about expertise or competence, especially in sensitive areas (e.g., health, finance, government services, legal).
    - 주요한 사항, 개인의 권리 또는 웰빙에 영향을 미치는 영역에서의 자동 의사 결정(예: 금융, 법률, 고용, 의료, 주택, 보험, 사회복지) / Automating decisions in areas that have significant consequences for individuals, rights, or well-being (e.g., finance, law, employment, healthcare, housing, insurance, social services)

5. 포르노 또는 성적 만족을 목적으로 제작된 콘텐츠를 비롯한 음란물을 생성(예: 성적 챗봇). 과학, 교육, 다큐멘터리 또는 예술용으로 제작된 콘텐츠는 여기에 포함되지 않습니다. / Generating sexually suggestive content, including pornography or content produced for the purpose of sexual gratification. This does not include content created for scientific, educational, document""";
