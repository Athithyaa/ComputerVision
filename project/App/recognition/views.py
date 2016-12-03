from django.http import HttpResponse
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.shortcuts import render_to_response
from django.shortcuts import get_object_or_404
from django.contrib import auth
from django.template.context_processors import csrf
from django.views.decorators.csrf import csrf_exempt
#from django.core.context_processors import csrf
#from django.views.decorators import csrf

import os
import json
import uuid

from django.http import JsonResponse
from classify_one import classify as classifier
from classify_one import classify_bow, classify_bow_gmm


def index(request):
    print("Hello")
    return render(request, "views/index.html")


@csrf_exempt
def classify(request):
    data = json.loads(request.body)
    print("classify: ", data)

    img = data['img']
    imgPath = os.path.join('recognition/static/images/', img)
    print("Image path: ", imgPath)

    if data['choice'] == '3':
        category = classifier(imgPath)
    elif data['choice'] == '2':
        category = classify_bow_gmm(imgPath)
    else:
        category = classify_bow(imgPath)

    #return render("hello sunil")
    return JsonResponse({'classifier': str(category)})