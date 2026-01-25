interface Env {
  ORDERS: KVNamespace;
}

interface QuizData {
  qt: string;
  dreamText: string;
  answers: {
    emotion: 'fear' | 'curiosity' | 'relief';
    frequency: 'first' | 'sometimes' | 'often';
    clarity: 'blurry' | 'mid' | 'clear';
  };
  segment: 'low' | 'mid' | 'high';
  createdAt: string;
}

const VALID_EMOTIONS = ['fear', 'curiosity', 'relief'];
const VALID_FREQUENCIES = ['first', 'sometimes', 'often'];
const VALID_CLARITIES = ['blurry', 'mid', 'clear'];
const VALID_SEGMENTS = ['low', 'mid', 'high'];

export const onRequestPost: PagesFunction<Env> = async (context) => {
  try {
    const data: QuizData = await context.request.json();

    // Validation
    if (!data.qt || data.qt.length < 32) {
      return Response.json({ error: 'Invalid qt' }, { status: 400 });
    }

    if (!data.dreamText || data.dreamText.length < 10 || data.dreamText.length > 1000) {
      return Response.json({ error: 'Invalid dream text' }, { status: 400 });
    }

    if (!data.answers || typeof data.answers !== 'object') {
      return Response.json({ error: 'Invalid answers' }, { status: 400 });
    }

    if (!VALID_EMOTIONS.includes(data.answers.emotion)) {
      return Response.json({ error: 'Invalid emotion' }, { status: 400 });
    }

    if (!VALID_FREQUENCIES.includes(data.answers.frequency)) {
      return Response.json({ error: 'Invalid frequency' }, { status: 400 });
    }

    if (!VALID_CLARITIES.includes(data.answers.clarity)) {
      return Response.json({ error: 'Invalid clarity' }, { status: 400 });
    }

    if (!VALID_SEGMENTS.includes(data.segment)) {
      return Response.json({ error: 'Invalid segment' }, { status: 400 });
    }

    // Store quiz data
    const quizRecord = {
      qt: data.qt,
      dreamText: data.dreamText.substring(0, 1000),
      answers: {
        emotion: data.answers.emotion,
        frequency: data.answers.frequency,
        clarity: data.answers.clarity,
      },
      segment: data.segment,
      createdAt: new Date().toISOString(),
    };

    await context.env.ORDERS.put(`quiz:${data.qt}`, JSON.stringify(quizRecord), {
      expirationTtl: 60 * 60 * 24 * 7, // 7 days
    });

    return Response.json({ success: true });
  } catch (error) {
    console.error('Quiz save error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};
