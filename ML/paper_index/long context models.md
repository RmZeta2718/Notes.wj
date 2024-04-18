Famous long context models

- [[@2023ExtendingContextWindowChen|RoPE-PI]] + direct fine-tuning:
    - [[@2023ExtendingContextWindowChen|RoPE-PI]] (up to 32K)
        - base model: LLaMA. Data: the Pile. Task: language modeling
        - Eval data: PG-19 / proof-pile. Sliding Window eval stride 256
        - settings: A100x128, bs 128,1000 steps (4B token for 32K)
    - [LongChat-7B/13B-16K](https://lmsys.org/blog/2023-06-29-longchat/#step-2-finetuning-on-curated-conversation-data)
        - base model: LLaMA. Data: Vicuna + [FastChat](https://github.com/lm-sys/FastChat) pipeline. Task: language modeling
        - cost: A100 \$3/h 7B: \$300 13B: \$700
    - NTK-aware
        - CodeLLaMA
    - [[@2023YaRNEfficientContextPeng|YaRN]]
- ABF
    - 
    - [[@2024DataEngineeringScalingFu|Data Engineering for Scaling Language Models to 128K Context, 2024]]
